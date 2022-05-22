part of dialog_bot.common.view;

class EndPoint extends FlowPoint {
  @override
  String get name => 'end';

  @override
  FutureOr<void> pass() {
    navigator.finish();
  }
}

class TodoPoint extends FlowPoint {
  @override
  String get name => 'todo';

  final RouteBuilder? next;

  TodoPoint({
    this.next,
  });

  @override
  FutureOr<void> pass() async {
    final Delayer delayer = Delayer(
      delayed: [
        () => message.reply(_emoji),
        () => message.reply(_reply),
      ],
      delay: Duration(seconds: 1),
    );

    await delayer.start();

    if (next is RouteBuilder)
      return navigator.next(
        next!(),
      );

    return navigator.finish();
  }

  static const String _emoji = '\u{1F643}';

  static const String _reply = //
      'Ой!\n'
      '\n'
      'Я только учусь выполнять эту команду, '
      'давай попробуем позже?';
}
