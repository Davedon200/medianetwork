import 'package:media_network/core/constants/breakpoints.dart';

abstract final class Responsive {
  static double horizontalPadding(double width) {
    if (Breakpoints.isMobile(width)) return 16;
    if (Breakpoints.isTablet(width)) return 24;
    return 40;
  }

  static double sectionSpacing(double width) {
    if (Breakpoints.isMobile(width)) return 24;
    if (Breakpoints.isTablet(width)) return 40;
    return 60;
  }

  static double headlineSize(double width, double base) {
    if (Breakpoints.isMobile(width)) return base * 0.65;
    if (Breakpoints.isTablet(width)) return base * 0.8;
    return base;
  }

  static double cardWidth(double screenWidth, double preferred) {
    if (Breakpoints.isMobile(screenWidth)) {
      return screenWidth * 0.75;
    }
    return preferred;
  }

  static double heroHeight(double viewportHeight) {
    return viewportHeight < 700 ? viewportHeight * 0.9 : viewportHeight;
  }
}
