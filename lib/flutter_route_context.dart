import 'package:flutter/material.dart';
import 'package:flutter_route/flutter_route.dart';
import 'package:flutter_route/flutter_route_config.dart';
import 'package:flutter_route/flutter_route_observer.dart';
import 'package:signals/signals_flutter.dart';

/// Gerenciador centralizado e estático para registro e resolução de rotas.
abstract class FlutterRouteContext {
  // Prevent instantiation
  const FlutterRouteContext._();

  // 1. Chave Global para acessar o NavigatorState em qualquer lugar do app sem BuildContext
  static final navigatorKey = GlobalKey<NavigatorState>();

  // HashMaps para busca O(1) de alta performance por Path e por Alias
  static final Map<String, FlutterRoute> _routesByAlias = {};
  static final Map<String, FlutterRoute> _routesByPath = {};

  // 2. Coleção interna de rotas registradas no main()
  static final List<FlutterRoute> _registeredRoutes = [];

  /// Rota inicial da aplicação
  static String? initialRoute;

  // 3. Estado Reativo (Signals) para o Observer acompanhar as rotas
  static final currentRoute = signal<FlutterRouteConfig?>(null);
  static final previousRoute = signal<FlutterRouteConfig?>(null);

  /// Define a rota inicial do app e retorna a própria rota
  static FlutterRoute setInitialRoute(FlutterRoute route) {
    initialRoute = route.path;
    return route;
  }

  // 4. Lista de Observers inicializada com o observer da aplicação
  static final List<NavigatorObserver> observers = [
    FlutterRouteObserver(),
  ];

  /// Método estático chamado no main() para registrar os objetos de rota
  static void registerRoutes(List<FlutterRoute> routes) {
    for (final route in routes) {
      _routesByAlias[route.alias] = route;
      _routesByPath[route.path] = route;
      _registeredRoutes.add(route);
    }
  }

  /// Adiciona observers dinamicamente (ex: FirebaseAnalyticsObserver)
  static void registerObserver(NavigatorObserver observer) {
    observers.add(observer);
  }

  /// Busca as configurações da rota pelo Path O(1)
  static FlutterRouteConfig? fromPath(String? path) {
    if (path == null) return null;
    return _routesByPath[path]?.config;
  }

  /// Busca as configurações da rota pelo Alias O(1)
  static FlutterRouteConfig? fromAlias(String alias) {
    return _routesByAlias[alias]?.config;
  }

  /// Callback estático pronto para conectar direto no `onGenerateRoute` do MaterialApp
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final matchedConfig = fromPath(settings.name);
    if (matchedConfig != null) {
      return matchedConfig.materialPage;
    }
    return null; // Aciona o onUnknownRoute se não encontrar
  }

  /// Callback estático para gerenciar rotas desconhecidas (404)
  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('Rota não encontrada: ${settings.name}')),
      ),
    );
  }

  // Helper de atalho seguro para o NavigatorState
  static NavigatorState? get navigator => navigatorKey.currentState;

  /// Navega empilhando uma nova rota pelo `path`
  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Navega empilhando uma nova rota pelo `alias`
  static Future<T?>? pushNamedByAlias<T extends Object?>(
    String alias, {
    Object? arguments,
  }) {
    final config = fromAlias(alias);
    if (config != null) {
      return navigator?.pushNamed<T>(
        config.path,
        arguments: arguments,
      );
    }
    return null;
  }

  /// Substitui a rota atual do topo por uma nova rota usando o `path`
  static Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigator?.pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  /// Substitui a rota atual do topo por uma nova rota usando o `alias`
  static Future<T?>? pushReplacementNamedByAlias<T extends Object?, TO extends Object?>(
    String alias, {
    TO? result,
    Object? arguments,
  }) {
    final config = fromAlias(alias);
    if (config != null) {
      return navigator?.pushReplacementNamed<T, TO>(
        config.path,
        result: result,
        arguments: arguments,
      );
    }
    return null;
  }

  /// Fecha a rota atual
  static void pop<T extends Object?>([T? result]) {
    navigator?.pop(result);
  }
}