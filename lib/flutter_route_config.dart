import 'package:flutter/material.dart';

typedef FlutterRouteAlias = String;
typedef FlutterRoutePath = String;

abstract class FlutterRouteConfig extends RouteSettings {
  final FlutterRouteAlias alias;
  final FlutterRoutePath path;

  const FlutterRouteConfig(this.alias, this.path) : super(name: path);

  MaterialPageRoute<dynamic> get materialPage;

  MaterialPageRoute<dynamic> route(BuildContext? context, Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}
