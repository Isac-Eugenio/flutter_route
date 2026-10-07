# flutter_route

Um framework leve e de alta performance para gerenciamento dinâmico de rotas no Flutter. Construído com **busca em tempo constante $O(1)$ via HashMap**, rastreamento reativo de estados powered by **Signals**, e desacoplamento total da lógica de navegação da árvore de UI.

---

## Recursos (Features)

- **Busca Instantânea $O(1)$**: Utiliza HashMaps internos para resolver rotas por `path` ou `alias` em tempo constante.
- **Navegação por Alias**: Navegue usando identificadores limpos e amigáveis (ex: `'profile_alias'`) em vez de strings de URLs estáticas.
- **Rastreamento Reativo de Rotas**: Integrado com o `signals_flutter` para acompanhar as rotas `currentRoute` e `previousRoute` reativamente em todo o app.
- **Navegação Sem `BuildContext`**: Suporte nativo à chave global de navegação (`FlutterRouteContext.pushNamed`, `pop`, etc.).
- **`NavigatorObserver` Integrado**: Observa eventos de ciclo de vida (`didPush`, `didPop`, `didReplace`) e atualiza os sinais automaticamente.
- **Zero Boilerplate no MaterialApp**: Expõe callbacks estáticos prontos para conectar direto no `onGenerateRoute`, `onUnknownRoute` e `navigatorObservers`.

---

## Começando

Adicione o `flutter_route` e o `signals_flutter` no seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_route: ^0.0.1
  signals_flutter: ^0.6.0