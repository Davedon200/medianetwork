import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';

class WebTextStyles {
  WebTextStyles._();

  static TextStyle heading(BuildContext context) => TextStyle(
        color: context.palette.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      );

  static TextStyle subheading(BuildContext context) => TextStyle(
        color: context.palette.textSecondary,
        fontSize: 19,
      );

  static TextStyle normal(BuildContext context) => TextStyle(
        color: context.palette.textPrimary,
        fontSize: 14,
      );

  static TextStyle onSurface(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 14,
      );

  static TextStyle onModal(BuildContext context) => TextStyle(
        color: context.palette.textOnModal,
        fontSize: 14,
      );

  static TextStyle onModalMuted(BuildContext context) => TextStyle(
        color: context.palette.textOnModalMuted,
        fontSize: 14,
      );
}
