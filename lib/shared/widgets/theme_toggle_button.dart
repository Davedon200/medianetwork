import 'package:flutter/material.dart';
import 'package:media_network/core/theme/theme_view_model.dart';
import 'package:provider/provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final themeVm = context.watch<ThemeViewModel>();

    return IconButton(
      icon: Icon(themeVm.isDark ? Icons.light_mode : Icons.dark_mode),
      color: iconColor,
      tooltip: themeVm.isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: () => themeVm.toggle(),
    );
  }
}
