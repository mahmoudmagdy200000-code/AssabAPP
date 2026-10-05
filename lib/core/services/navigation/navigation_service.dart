import 'package:flutter/material.dart';

import 'i_navigation_service.dart';

class NavigationService implements INavigationService {
  NavigationService._internal();

  static final NavigationService I = NavigationService._internal();

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String? currentRouteName;

  NavigatorState get _nav {
    final nav = navigatorKey.currentState;
    assert(
      nav != null,
      'NavigatorState is null. Did you set MaterialApp.navigatorKey?',
    );
    return nav!;
  }

  @override
  BuildContext? get context => navigatorKey.currentContext;

  @override
  Future<T?> pushNamed<T extends Object?>(String route, {Object? arguments}) {
    return _nav.pushNamed<T>(route, arguments: arguments);
  }

  @override
  Future<T?> push<T extends Object?>(Route<T> route) {
    return _nav.push<T>(route);
  }

  @override
  Future<T?> replaceWithNamed<T extends Object?, TO extends Object?>(
    String route, {
    Object? arguments,
    TO? result,
  }) {
    return _nav.pushReplacementNamed<T, TO>(
      route,
      arguments: arguments,
      result: result,
    );
  }

  @override
  Future<T?> replaceWith<T extends Object?, TO extends Object?>(
    Route<T> route, {
    TO? result,
  }) {
    return _nav.pushReplacement<T, TO>(route, result: result);
  }

  @override
  Future<T?> offAllNamed<T extends Object?>(
    String route, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) {
    return _nav.pushNamedAndRemoveUntil<T>(
      route,
      predicate ?? (Route<dynamic> r) => false,
      arguments: arguments,
    );
  }

  @override
  void pop<T extends Object?>([T? result]) => _nav.pop<T>(result);

  @override
  void popToFirst() => _nav.popUntil((route) => route.isFirst);

  @override
  void popUntil(bool Function(Route p1) predicate) {
    _nav.popUntil(predicate);
  }

  @override
  bool canPop() => _nav.canPop();
}
