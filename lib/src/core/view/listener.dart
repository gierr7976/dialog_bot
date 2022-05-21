part of dialog_bot.core.view;

abstract class MessageListener {
  List<Stream<TeleDartMessage>> on(TeleDart tg);

  Future<void> _handle(TeleDart tg, TeleDartMessage message) async {
    final Navigator navigator = Navigator();

    await navigator.start(
      tg: tg,
      point: from,
      message: message,
    );
  }

  @protected
  FlowPoint get from;
}
