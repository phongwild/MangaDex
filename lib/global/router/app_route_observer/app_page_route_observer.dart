import 'package:flutter/material.dart';
import 'package:app/core/app_log.dart';

class AppPageRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  String? currentRoute;
  String? previousRoute;

  void _setCurrentRoute(PageRoute<dynamic> route) {
    final String screenName = route.settings.name ?? '';
    currentRoute = screenName;
    dlog('screenName $currentRoute');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute != null) {
      this.previousRoute = previousRoute.settings.name;
    }
    if (route is PageRoute) {
      _setCurrentRoute(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      previousRoute = oldRoute.settings.name;
    }
    if (newRoute is PageRoute) {
      _setCurrentRoute(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      this.previousRoute = previousRoute.settings.name;
      _setCurrentRoute(previousRoute);
    }
  }
}
