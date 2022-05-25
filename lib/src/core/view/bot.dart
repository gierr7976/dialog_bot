part of dialog_bot.core.view;

class FlowBot {
  final String token;
  final RootPoint _root;

  FlowBot({
    required this.token,
    required List<FlowPoint> roots,
    String home = BotConfig.home_route,
  }) : _root = RootPoint(
          roots: roots,
          home: home,
        );

  List<BotCommand> get publicCommands {
    final List<FlowPoint> roots = _root.build();
    final List<InputPoint> commandInputs = roots
        .where(
          (point) => point is InputPoint && point.trigger is CommandInput,
        )
        .map((point) => point as InputPoint)
        .toList();

    if (commandInputs.isNotEmpty)
      return [
        for (InputPoint point in commandInputs)
          (point.trigger as CommandInput).botCommand,
      ];

    return [];
  }

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
    final _InputExtractor extractor = _InputExtractor(_root);
    final List<InputScope> scopes = extractor.on(tg);

    for (InputScope scope in scopes)
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
      root: _root,
      scope: scope,
    );

    return navigator.run();
  }
}
