import 'package:assab/core/di/dependency_injection.dart';
import 'package:assab/core/services/cancel_request_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../utils/app_logger.dart';
import 'navigation_service.dart';

@LazySingleton()
class RequestRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final _manager = getIt<CancelRequestService>();

  String? _getRouteName(Route? route) {
    return route?.settings.name;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);

    final routeName = _getRouteName(route);

    if (routeName != null) {
      NavigationService.I.currentRouteName = routeName;

      AppLogger.log('PUSH: $routeName', tag: 'RouteObserver');
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    final routeName = _getRouteName(route);
    final prevRouteName = _getRouteName(previousRoute);

    if (routeName != null) {
      _manager.cancelRoute(routeName);

      AppLogger.log('POP: $routeName', tag: 'RouteObserver');
    }

    if (prevRouteName != null) {
      NavigationService.I.currentRouteName = prevRouteName;
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);

    final routeName = _getRouteName(route);
    if (routeName != null) {
      _manager.cancelRoute(routeName);

      AppLogger.log('REMOVE: $routeName', tag: 'RouteObserver');
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    final oldRouteName = _getRouteName(oldRoute);
    final newRouteName = _getRouteName(newRoute);

    if (oldRouteName != null) {
      _manager.cancelRoute(oldRouteName);

      AppLogger.log('REPLACE old: $oldRouteName', tag: 'RouteObserver');
    }

    if (newRouteName != null) {
      NavigationService.I.currentRouteName = newRouteName;

      AppLogger.log('REPLACE new: $newRouteName', tag: 'RouteObserver');
    }
  }
}
