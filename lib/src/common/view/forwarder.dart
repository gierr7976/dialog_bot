part of dialog_bot.common.view;

class Forwarder extends FlowPoint {
  @override
  String get name => 'forward';

  final Map<String, RouteBuilder> routes;

  final String fallback;

  Forwarder({
    required this.routes,
    this.fallback = BotConfig.home_route,
  }) : assert(
          routes.containsKey(fallback),
          'Fallback not exists',
        );

  @override
  FutureOr<void> pass() {
    final String to = message.text!;

    final RouteBuilder builder = routes[to] ?? routes[fallback]!;

    return navigator.next(
      builder(),
    );
  }
}
