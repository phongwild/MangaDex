import 'package:flutter/material.dart';

abstract class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {dynamic arguments});

  Future<dynamic> replaceTo(String routeName, {dynamic arguments});

  Future<dynamic> removeUntil(String routeName, {dynamic arguments});

  void popUntil(String routeName, {dynamic arguments, bool safety = true});

  Future<dynamic> popAndNavigateTo(String routeName, {dynamic arguments});

  Future<dynamic>? pushNamedAndRemoveUntilSafety(
    String newRouteName,
    String predicateRouteName, {
    Object? arguments,
  });

  void goBack<T extends Object?>([T? result]);
}

class NavigationServiceImpl extends NavigationService {
  @override
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> replaceTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  @override
  Future<dynamic> removeUntil(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  @override
  void goBack<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }

  @override
  void popUntil(String routeName, {arguments, bool safety = true}) {
    if (safety && navigatorKey.currentContext != null) {
      return _popUntilSafety(navigatorKey.currentContext!, routeName,
          arguments: arguments);
    }

    return navigatorKey.currentState!
        .popUntil((route) => route.settings.name == routeName);
  }

  @override
  Future popAndNavigateTo(String routeName, {arguments}) {
    return navigatorKey.currentState!
        .popAndPushNamed(routeName, arguments: arguments);
  }

  void _popUntilSafety(BuildContext context, String routeName,
      {dynamic arguments}) {
    Navigator.popUntil(context, (route) => getRoutePredicate(route, routeName));
  }

  bool getRoutePredicate(Route<dynamic> route, String routeName) {
    if (route.isFirst) return true;

    return !route.willHandlePopInternally &&
        route is ModalRoute &&
        route.settings.name == routeName;
  }

  @override
  Future? pushNamedAndRemoveUntilSafety(
      String newRouteName, String predicateRouteName,
      {Object? arguments}) {
    if (navigatorKey.currentContext == null) return null;

    return Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
        newRouteName, (route) => getRoutePredicate(route, predicateRouteName),
        arguments: arguments);
  }
}
