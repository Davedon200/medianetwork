import 'package:flutter/material.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(36),
    this.margin,
    this.borderRadius = 28,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: context.raisedCardDecoration(radius: borderRadius),
      child: child,
    );
  }
}
