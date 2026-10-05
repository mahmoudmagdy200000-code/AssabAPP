import 'package:flutter/material.dart';

abstract class INavigationService {
  GlobalKey<NavigatorState> get navigatorKey;

  Future<T?> pushNamed<T extends Object?>(String route, {Object? arguments});

  Future<T?> push<T extends Object?>(Route<T> route);

  Future<T?> replaceWithNamed<T extends Object?, TO extends Object?>(
    String route, {
    Object? arguments,
    TO? result,
  });

  Future<T?> replaceWith<T extends Object?, TO extends Object?>(
    Route<T> route, {
    TO? result,
  });

  Future<T?> offAllNamed<T extends Object?>(
    String route, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  });

  void pop<T extends Object?>([T? result]);

  void popToFirst();

  void popUntil(bool Function(Route<dynamic>) predicate);

  bool canPop();

  BuildContext? get context;
}
