part of dialog_bot.core.view;

class FlowBot {
  final String token;

  final PointRouter _router;

  FlowBot({
    required this.token,
    required List<FlowPoint> roots,
    String home = BotConfig.home_route,
  }) : _router = PointRouter(
          RootPoint(
            roots: roots,
            home: home,
          ),
        );

  List<BotCommand> get publicCommands => [
        for (InputPoint point in _router.globalInputs)
          if (point.trigger is CommandInput)
            (point.trigger as CommandInput).botCommand,
      ];

  Future<void> start() async {
    final User user = await Telegram(token).getMe();

    final TeleDart tg = TeleDart(
      token,
      Event(
        user.username!,
      ),
    );

    tg.start();

    tg.setMyCommands(publicCommands);

    subscribe(tg);
  }

  @mustCallSuper
  void subscribe(TeleDart tg) {
    for (InputScope scope in _router.inputScopes)
      scope.build(tg).listen(
            (message) => _listener(
              tg: tg,
              message: message,
              scope: scope,
            ),
          );
  }

  Future<void> _listener({
    required TeleDart tg,
    required TeleDartMessage message,
    required InputScope scope,
  }) {
    final FlowNavigator navigator = FlowNavigator(
      tg: tg,
      message: message,
      router: _router,
      scope: scope,
    );

    return navigator.run();
  }
}
