part of dialog_bot.common.view;

class Forwarder extends FlowPoint {
  @override
  String get name => 'forward';

  final Map<String, FlowPoint> routes;

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

    final FlowPoint next = routes[to] ?? routes[fallback]!;

    return navigator.next(next);
  }
}
