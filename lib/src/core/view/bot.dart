part of dialog_bot.core.view;

class FlowBot {
  final String token;
  final List<MessageListener> listeners;
  final List<BotCommand> publicCommands;

  FlowBot({
    required this.token,
    required this.listeners,
    this.publicCommands = const [],
  });

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
    for (MessageListener listener in listeners)
      for (Stream<TeleDartMessage> stream in listener.on(tg))
        stream.listen(
          (message) => listener._handle(tg, message),
        );
  }
}
