import 'package:flutter/material.dart';
import 'package:flutter_route/flutter_route_config.dart';

abstract class FlutterRoute {
  FlutterRoute();

  String get path => config.path;
  String get alias => config.alias;

  /// Método abstrato para criar a configuração concreta da rota
  FlutterRouteConfig createConfig();

  /// Cria a configuração lazily sem gerar recursão
  late final FlutterRouteConfig config = createConfig();

  /// Getter para expor diretamente a rota do Material
  Route<dynamic> get route => config.materialPage;
}
