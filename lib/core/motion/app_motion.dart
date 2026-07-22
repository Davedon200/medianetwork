import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 500);
  static const staggerStep = Duration(milliseconds: 50);
  static const curve = Curves.easeOutCubic;
  static const dialogScaleBegin = 0.95;
  static const routeSlideOffset = 12.0;
}
