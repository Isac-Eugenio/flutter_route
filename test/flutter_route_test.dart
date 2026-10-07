
import 'package:flutter/material.dart';
import 'package:flutter_route/flutter_route_context.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_route.dart';


class Teste extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: FlutterRouteContext.navigatorKey,
      navigatorObservers: FlutterRouteContext.observers,
      onGenerateRoute: FlutterRouteContext.onGenerateRoute,
      onUnknownRoute: FlutterRouteContext.onUnknownRoute,
      initialRoute: FlutterRouteContext.initialRoute,
      home: Material()
    );
  }
}

void main() {
  testWidgets('Deve carregar a tela inicial TestRoute com sucesso', (WidgetTester tester) async {
    // 1. Inicializa as rotas no contexto
    FlutterRouteContext.registerRoutes([
      FlutterRouteContext.setInitialRoute(TestRoute()),
    ]);

    // 2. Renderiza o aplicativo
    await tester.pumpWidget(const Teste());
    await tester.pumpAndSettle(); // Aguarda a renderização completa da rota

    // 3. Valida se algum elemento esperado da TestRoute está na tela
    // Exemplo: expect(find.text('Minha Tela de Teste'), findsOneWidget);
  });
}