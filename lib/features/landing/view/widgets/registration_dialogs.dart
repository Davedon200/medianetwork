import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/animated_dialog.dart';
import 'package:media_network/core/theme/text_styles.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/features/auth/view/widgets/sign_in_link_dialog.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';
import 'package:media_network/features/landing/viewmodel/landing_view_model.dart';
import 'package:provider/provider.dart';

Future<void> showRegistrationSuccessDialog(
  BuildContext context,
  LandingViewModel viewModel,
) {
  final palette = context.palette;

  return showAnimatedDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Dialog(
            backgroundColor: palette.surfaceModal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: palette.accentPurple.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: palette.accentPurple,
                      size: 45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Registration Successful',
                    textAlign: TextAlign.center,
                    style: WebTextStyles.onModal(context).copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your registration has been successfully submitted.\nWe will review your details and get back to you soon.',
                    textAlign: TextAlign.center,
                    style: WebTextStyles.onModalMuted(context).copyWith(
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: palette.accentPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final email = viewModel.emailController.text.trim();
                        Navigator.of(dialogContext).pop();
                        viewModel.clearForm();
                        viewModel.toggleRegisterForm(false);
                        if (email.isEmpty) return;
                        try {
                          final authVm = context.read<AuthViewModel>();
                          final outcome = await authVm.sendSignInLink(email);
                          if (!context.mounted) return;
                          switch (outcome) {
                            case SignInOutcome.emailLinkSent:
                              await showSignInLinkSentDialog(context, email);
                            case SignInOutcome.sessionStarted:
                              context.go('/home');
                          }
                        } catch (e, st) {
                          if (!context.mounted) return;
                          final authVm = context.read<AuthViewModel>();
                          if (AuthViewModel.isAuthUnavailable(e)) {
                            await authVm.signInWithLocalSession(email);
                            if (context.mounted) context.go('/home');
                            return;
                          }
                          AppErrorLog.log(
                            e,
                            st,
                            tag: 'RegistrationDialogs',
                            op: 'sendSignInLinkAfterRegistration',
                          );
                          await showSignInLinkErrorDialog(context);
                        }
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> showAlreadyRegisteredDialog(
  BuildContext context,
  LandingViewModel viewModel,
) {
  final palette = context.palette;

  return showAnimatedDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: palette.surfaceModal,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              color: palette.accentPurple,
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              'Already Registered',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: palette.accentPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You have already registered for this program.',
              style: WebTextStyles.onModal(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                viewModel.clearForm();
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.accentPurple,
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    ),
  );
}
