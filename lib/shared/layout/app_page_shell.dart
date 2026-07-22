import 'package:flutter/material.dart';
import 'package:media_network/shared/layout/app_scaffold.dart';
import 'package:media_network/shared/layout/light_panel_scope.dart';

class AppPageShell extends StatelessWidget {
  const AppPageShell({
    super.key,
    required this.child,
    this.padding = 36,
    this.scrollable = true,
  });

  final Widget child;
  final double padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      solidPageBackground: true,
      padding: EdgeInsets.fromLTRB(padding, 16, padding, padding),
      constrainWidth: false,
      scrollable: scrollable,
      child: LightPanelScope(child: child),
    );
  }
}
