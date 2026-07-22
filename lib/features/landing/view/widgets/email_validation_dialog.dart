import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/animated_dialog.dart';
import 'package:media_network/core/theme/text_styles.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/features/landing/viewmodel/landing_view_model.dart';
import 'package:media_network/shared/widgets/web_button.dart';

Future<EmailCheckResult?> showEmailValidationDialog(
  BuildContext context,
  LandingViewModel viewModel,
) {
  return showAnimatedDialog<EmailCheckResult>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) =>
        _EmailValidationDialog(viewModel: viewModel),
  );
}

class _EmailValidationDialog extends StatefulWidget {
  const _EmailValidationDialog({required this.viewModel});

  final LandingViewModel viewModel;

  @override
  State<_EmailValidationDialog> createState() => _EmailValidationDialogState();
}

class _EmailValidationDialogState extends State<_EmailValidationDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  bool _isChecking = false;
  bool _notRegistered = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onProceed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isChecking = true);

    try {
      final checkResult = await widget.viewModel.checkEmail(
        _emailController.text,
      );
      if (!mounted || checkResult == null) return;
      Navigator.pop(context, checkResult);
    } catch (e, st) {
      if (!mounted) return;
      AppErrorLog.log(e, st, tag: 'EmailValidationDialog', op: 'checkEmail');
      setState(() => _isChecking = false);
      final message = e is FirebaseException && e.code == 'permission-denied'
          ? 'Unable to verify email — Firebase permissions need to be updated.'
          : 'Unable to verify email. Please try again.';
      await _showVerificationErrorDialog(message);
    }
  }

  Future<void> _showVerificationErrorDialog(String message) {
    final palette = context.palette;
    return showAnimatedDialog<void>(
      context: context,
      builder: (errorContext) => AlertDialog(
        backgroundColor: palette.surfaceModal,
        title: Text(
          'Verification Failed',
          style: WebTextStyles.onModal(context).copyWith(
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(message, style: WebTextStyles.onModalMuted(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(errorContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: palette.surfaceModal,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            _notRegistered ? 'Register Now' : 'Enter Registered Email',
            style: WebTextStyles.onModal(context).copyWith(
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _notRegistered
                ? Text(
                    'No account found with this email.',
                    key: const ValueKey('error'),
                    style: WebTextStyles.onModal(context).copyWith(
                      color: scheme.error,
                    ),
                  )
                : const SizedBox(key: ValueKey('empty')),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: WebTextStyles.onModalMuted(context).copyWith(fontSize: 16),
            filled: true,
            fillColor: palette.surfaceModal,
          ),
          style: WebTextStyles.onModal(context).copyWith(fontSize: 16),
          onChanged: (_) {
            if (_notRegistered) setState(() => _notRegistered = false);
          },
          validator: (value) {
            if (value == null || value.isEmpty) return 'Email is required';
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
            return null;
          },
        ),
      ),
      actions: [
        if (_notRegistered)
          Row(
            children: [
              TextButton(
                onPressed: _isChecking ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              WebButton(
                decoration: boxDecoration,
                textColor: Colors.white,
                bodytext: 'Register Now',
                onPressed: () =>
                    Navigator.pop(context, EmailCheckResult.notExists),
              ),
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _isChecking ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              _isChecking
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : WebButton(
                      decoration: boxDecoration,
                      textColor: Colors.white,
                      bodytext: 'Proceed',
                      onPressed: _onProceed,
                    ),
            ],
          ),
      ],
    );
  }
}
