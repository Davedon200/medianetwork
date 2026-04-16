import 'package:flutter/material.dart';
import 'package:media_network/features/explore_page.dart';
import 'package:media_network/features/landing_page.dart';

import 'package:media_network/widgets/widget.dart';

class WebRoutes {
  WebRoutes._();

  static final WebRoutes instance = WebRoutes._();
  static final _logger = WebUtils.getLogger("AppRoutes");

  static const String home = "/";
  static const String explorepage = "/explorepage";

  Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name;
    _logger.d("Route Name: $routeName");

    switch (routeName) {
      case WebRoutes.home:
        return MaterialPageRoute(
          builder: (context) => const RhapsodyLandingPage(),
        );
      case WebRoutes.explorepage:
        return MaterialPageRoute(builder: (context) => const ExplorePage());
    }
  }
}
