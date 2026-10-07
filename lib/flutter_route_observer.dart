import 'package:flutter/material.dart';
import 'package:flutter_route/flutter_route_context.dart';

class FlutterRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    // Registra a rota antiga como anterior
    if (previousRoute?.settings.name != null) {
      final prev = FlutterRouteContext.fromPath(previousRoute!.settings.name);
      FlutterRouteContext.previousRoute.set(prev);
    }

    // Registra a nova rota como atual
    if (route.settings.name != null) {
      final current = FlutterRouteContext.fromPath(route.settings.name);
      FlutterRouteContext.currentRoute.set(current);
    }

    debugPrint(
      "Route push: atual ${FlutterRouteContext.currentRoute.get()} \vert{} anterior${FlutterRouteContext.previousRoute.get()}",
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    // Ao fazer POP, a rota que assume o topo é a `previousRoute`
    if (previousRoute?.settings.name != null) {
      final current = FlutterRouteContext.fromPath(previousRoute!.settings.name);

      // O topo antigo era a `route` que sofreu o pop
      final prev = route.settings.name != null
          ? FlutterRouteContext.fromPath(route.settings.name)
          : null;

      FlutterRouteContext.previousRoute.set(prev);
      FlutterRouteContext.currentRoute.set(current);
    }

    debugPrint(
      "Route pop: voltou para ${FlutterRouteContext.currentRoute.get()} \vert{} veio de${FlutterRouteContext.previousRoute.get()}",
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (oldRoute?.settings.name != null) {
      FlutterRouteContext.previousRoute.set(
        FlutterRouteContext.fromPath(oldRoute!.settings.name),
      );
    }
    if (newRoute?.settings.name != null) {
      FlutterRouteContext.currentRoute.set(
        FlutterRouteContext.fromPath(newRoute!.settings.name),
      );
    }

    debugPrint(
      "Route replace: nova ${FlutterRouteContext.currentRoute.get()} \vert{} antiga${FlutterRouteContext.previousRoute.get()}",
    );
  }
}