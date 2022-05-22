part of dialog_bot.common.view;

typedef MessageStreamBuilder = Stream<TeleDartMessage> Function(TeleDart tg);

class InputListener extends AuthenticatedListener {
  final String preferred;

  final Map<String, FlowPoint> routes;

  final List<MessageStreamBuilder> listen;

  InputListener({
    required this.preferred,
    required this.routes,
    required this.listen,
  });

  @override
  List<Stream<TeleDartMessage>> on(TeleDart tg) => [
        for (MessageStreamBuilder builder in listen) builder(tg),
      ];

  @override
  FlowPoint get onAuthenticated => Router(
        routes: routes,
        preferred: preferred,
      );

  @override
  FlowPoint get onUnauthenticated => EndPoint();
}
