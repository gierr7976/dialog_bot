part of dialog_bot.core.view;

class FlowBot {
  final String token;
  final List<FlowPoint> roots;

  FlowBot({
    required this.token,
    required this.roots,
  }) : assert(roots.isNotEmpty);

  List<BotCommand> get publicCommands => [
        for (FlowPoint point in roots)
          for (Input trigger in point.triggers)
            if (trigger is CommandInput)
              BotCommand(
                command: trigger.command,
                description: trigger.description,
              ),
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
    final List<Input> inputs = [
      for (FlowPoint point in roots) ...[
        ...point.triggers,
        ...(point.build() ?? []).expand((sub) => sub.triggers),
      ],
    ];

    final List<Input> unique = [];

    for (Input input in inputs) if (!unique.contains(input)) unique.add(input);

    for (Input input in unique)
      input.build(tg).listen(
            (message) => _listener(
              tg: tg,
              message: message,
              trigger: input,
            ),
          );
  }

  Future<void> _listener({
    required TeleDart tg,
    required TeleDartMessage message,
    required Input trigger,
  }) async {
    final FlowNavigator navigator = FlowNavigator(
      tg: tg,
      message: message,
      trigger: trigger,
      roots: roots,
    );

    await navigator.run();
  }
}
