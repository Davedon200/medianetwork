import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/extensions/theme_context_ext.dart';
import 'package:media_network/core/responsive/responsive.dart';
import 'package:media_network/shared/widgets/app_nav_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
    this.constrainWidth = true,
    this.scrollable = true,
    this.solidPageBackground = false,
    this.applyResponsivePadding = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool constrainWidth;
  final bool scrollable;
  final bool solidPageBackground;
  final bool applyResponsivePadding;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final width = MediaQuery.of(context).size.width;
    final currentPath = GoRouterState.of(context).uri.path;
    final horizontalPad = Responsive.horizontalPadding(width);

    final resolvedPadding = padding == EdgeInsets.zero && applyResponsivePadding
        ? EdgeInsets.symmetric(horizontal: horizontalPad)
        : padding;

    final paddedChild = constrainWidth
        ? Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: resolvedPadding,
                child: child,
              ),
            ),
          )
        : Padding(
            padding: resolvedPadding,
            child: SizedBox(width: double.infinity, child: child),
          );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: solidPageBackground ? palette.surfaceCard : null,
            decoration: solidPageBackground
                ? null
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        palette.pageGradientStart,
                        palette.pageGradientEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
          ),
          Column(
            children: [
              AppNavBar(currentPath: currentPath),
              Expanded(
                child: scrollable
                    ? SingleChildScrollView(child: paddedChild)
                    : SizedBox.expand(child: paddedChild),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
