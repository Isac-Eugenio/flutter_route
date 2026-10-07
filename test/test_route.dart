import 'package:flutter/material.dart';
import 'package:flutter_route/flutter_route.dart';
import 'package:flutter_route/flutter_route_config.dart';

class TestRoute extends FlutterRoute {
  new();

  @override
  FlutterRouteConfig createConfig() => TestRouteConfig("teste", "/teste_view");
}

class TestRouteConfig extends FlutterRouteConfig {
  const new(super.alias, super.path);

  @override
  MaterialPageRoute<dynamic> get materialPage => route(null, Scaffold());
}
