import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_network/core/motion/app_motion.dart';

CustomTransitionPage<T> animatedPage<T>({
  required LocalKey key,
  required Widget child,
  Duration? duration,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: duration ?? AppMotion.normal,
    reverseTransitionDuration: duration ?? AppMotion.normal,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
