import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get currentContext =>
      navigatorKey.currentContext ?? Get.context;

  static NavigatorState? get navigator => navigatorKey.currentState;

  static Future<T?> push<T>(Widget page, {String? routeName}) {
    return Navigator.of(currentContext!).push<T>(
      MaterialPageRoute(
        builder: (context) => page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  static Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(currentContext!).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacement<T, TO>(Widget page, {String? routeName}) {
    return Navigator.of(currentContext!).pushReplacement<T, TO>(
      MaterialPageRoute(
        builder: (context) => page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(
    Widget page, {
    String? routeName,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.of(currentContext!).pushAndRemoveUntil<T>(
      MaterialPageRoute(
        builder: (context) => page,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
      predicate ?? (_) => false,
    );
  }

  static void pop<T>([T? result]) {
    if (navigator?.canPop() ?? false) {
      navigator?.pop<T>(result);
    }
  }

  static void popUntil(String routeName) {
    navigator?.popUntil(ModalRoute.withName(routeName));
  }
}
