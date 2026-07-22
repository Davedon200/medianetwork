import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/motion/animated_dialog.dart';
import 'package:media_network/core/theme/text_styles.dart';

const _loginErrorMessage = 'Error logging in. Try again.';

Future<void> showSignInLinkErrorDialog(BuildContext context) {
  final palette = context.palette;

  return showAnimatedDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: palette.surfaceModal,
      title: Text(
        'Unable to sign in',
        style: WebTextStyles.onModal(context).copyWith(
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        _loginErrorMessage,
        style: WebTextStyles.onModalMuted(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

Future<void> showSignInLinkSentDialog(BuildContext context, String email) {
  final palette = context.palette;

  return showAnimatedDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: palette.surfaceModal,
      title: Text(
        'Check your email',
        style: WebTextStyles.onModal(context).copyWith(
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        'We sent a sign-in link to $email. Open the link in your email to continue.',
        style: WebTextStyles.onModalMuted(context),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
