import 'package:flutter/material.dart';
import 'package:rhapsody_media_network/admin/admin_dashboard.dart';
import 'package:rhapsody_media_network/features/explore_page.dart';
import 'package:rhapsody_media_network/features/home_page.dart';
import 'package:rhapsody_media_network/features/landing_page.dart';
import 'package:rhapsody_media_network/features/media_boost_page.dart';
import 'package:rhapsody_media_network/features/resource_page.dart';
import 'package:rhapsody_media_network/widgets/widget.dart';

class WebRoutes {
  WebRoutes._();

  static final WebRoutes instance = WebRoutes._();
  static final _logger = WebUtils.getLogger("AppRoutes");

  static const String home = "/";
  static const String explorepage = "/explorepage";
  static const String admin = "/admin";
  static const String mediaboostpage = "/mediaboostpage";
  static const String getstartedpage = "/getstartedpage";
  static const String resource = "/resource";

  Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name;
    _logger.d("Route Name: $routeName");

    switch (routeName) {
      case WebRoutes.home:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case WebRoutes.getstartedpage:
        return MaterialPageRoute(
          builder: (context) => const RhapsodyLandingPage(),
        );
      case WebRoutes.explorepage:
        return MaterialPageRoute(builder: (context) => const ExplorePage());
      case WebRoutes.admin:
        return MaterialPageRoute(builder: (context) => const AdminDashboard());
      case WebRoutes.mediaboostpage:
        return MaterialPageRoute(builder: (context) => const MediaBoost());
      case WebRoutes.resource:
        return MaterialPageRoute(builder: (context) => const ResourcePage());
    }
    return null;
  }
}
