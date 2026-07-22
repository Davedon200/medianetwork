import 'package:flutter/material.dart';

class LightPanelScope extends InheritedWidget {
  const LightPanelScope({super.key, required super.child});

  static bool isInside(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LightPanelScope>() != null;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
