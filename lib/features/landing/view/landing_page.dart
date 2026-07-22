import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/data/repositories/analytics_repository.dart';
import 'package:media_network/data/repositories/registration_repository.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/features/auth/view/widgets/sign_in_link_dialog.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/landing/view/widgets/about_section.dart';
import 'package:media_network/features/landing/view/widgets/email_validation_dialog.dart';
import 'package:media_network/features/landing/view/widgets/hero_section.dart';
import 'package:media_network/features/landing/view/widgets/landing_footer.dart';
import 'package:media_network/features/landing/view/widgets/registration_dialogs.dart';
import 'package:media_network/features/landing/view/widgets/registration_form.dart';
import 'package:media_network/features/landing/viewmodel/landing_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.initialPath});

  final String initialPath;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LandingViewModel(
        registrationRepository: context.read<RegistrationRepository>(),
        analyticsRepository: context.read<AnalyticsRepository>(),
      ),
      child: _LandingView(initialPath: initialPath),
    );
  }
}

class _LandingView extends StatefulWidget {
  const _LandingView({required this.initialPath});

  final String initialPath;

  @override
  State<_LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<_LandingView> {
  final ScrollController _scrollController = ScrollController();
  GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  LandingViewModel? _viewModel;
  bool _initialized = false;
  bool _eventScheduled = false;
  LandingEvent? _lastHandledEvent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    if (!mounted || _initialized) return;
    _initialized = true;

    _viewModel = context.read<LandingViewModel>();
    _viewModel!.addListener(_onViewModelChanged);
    await _viewModel!.init(path: widget.initialPath);
    if (!mounted) return;
    _scheduleEventHandling();
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_onViewModelChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    final event = _viewModel?.pendingEvent;
    if (event != null && event != _lastHandledEvent) {
      _scheduleEventHandling();
    }
  }

  void _scheduleEventHandling() {
    if (_eventScheduled) return;
    _eventScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eventScheduled = false;
      if (!mounted) return;
      _handlePendingEvent();
    });
  }

  void _openRegistrationForm(LandingViewModel viewModel) {
    _registrationFormKey = GlobalKey<FormState>();
    viewModel.toggleRegisterForm(true);
  }

  Future<void> _completeSignIn(String email) async {
    final authVm = context.read<AuthViewModel>();
    try {
      final outcome = await authVm.sendSignInLink(email);
      if (!mounted) return;
      switch (outcome) {
        case SignInOutcome.emailLinkSent:
          await showSignInLinkSentDialog(context, email);
        case SignInOutcome.sessionStarted:
          context.go('/home');
      }
    } catch (e, st) {
      if (!mounted) return;
      if (AuthViewModel.isAuthUnavailable(e)) {
        await authVm.signInWithLocalSession(email);
        if (mounted) context.go('/home');
        return;
      }
      AppErrorLog.log(e, st, tag: 'LandingPage', op: 'sendSignInLink');
      await showSignInLinkErrorDialog(context);
    }
  }

  Future<void> _handleExplore(LandingViewModel viewModel) async {
    final result = await showEmailValidationDialog(context, viewModel);
    if (!mounted || result == null) return;

    switch (result) {
      case EmailCheckResult.exists:
        final email = viewModel.enteredEmail;
        if (email == null || !mounted) return;
        await _completeSignIn(email);
      case EmailCheckResult.notExists:
        _registrationFormKey = GlobalKey<FormState>();
        viewModel.onEmailNotExists();
    }
  }

  Future<void> _handlePendingEvent() async {
    final viewModel = _viewModel;
    if (viewModel == null) return;

    final event = viewModel.pendingEvent;
    if (event == null) return;

    viewModel.clearPendingEvent();
    _lastHandledEvent = event;

    switch (event) {
      case LandingEvent.navigateToExplore:
        if (mounted) {
          final email = viewModel.enteredEmail;
          if (email != null) {
            await _completeSignIn(email);
          } else {
            await _handleExplore(viewModel);
          }
        }
      case LandingEvent.showSuccessDialog:
        await showRegistrationSuccessDialog(context, viewModel);
      case LandingEvent.showAlreadyRegisteredDialog:
        await showAlreadyRegisteredDialog(context, viewModel);
      case LandingEvent.showEmailDialog:
        await _handleExplore(viewModel);
    }

    _lastHandledEvent = null;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LandingViewModel>();
    final width = MediaQuery.of(context).size.width;
    final isMobile = !Breakpoints.isDesktop(width);

    final palette = context.palette;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  palette.landingGradientStart,
                  palette.landingGradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                LandingHeroSection(
                  isMobile: isMobile,
                  scrollController: _scrollController,
                  onRegister: () => _openRegistrationForm(viewModel),
                  onExplore: () => _handleExplore(viewModel),
                ),
                if (!viewModel.showRegisterForm)
                  Container(
                    width: double.infinity,
                    color: palette.surfaceAbout,
                    child: LandingAboutSection(isMobile: isMobile),
                  ),
                const LandingFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (viewModel.showRegisterForm)
            RegistrationFormOverlay(
              key: ObjectKey(_registrationFormKey),
              formKey: _registrationFormKey,
              viewModel: viewModel,
              onClose: () => viewModel.toggleRegisterForm(false),
              onSubmit: () =>
                  viewModel.submitRegistration(_registrationFormKey),
            ),
        ],
      ),
    );
  }
}
