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
  static const String _reply = //
      'Упс!\n'
      '\n'
      'Этот раздел пока разрабатывается';

  static const String _emoji = '\u2692';

  @override
  String get name => 'todo';

  @override
  FutureOr<void> pass() async {
    await message.reply(_emoji);
    await message.reply(_reply);

    navigator.finish();
  }
}
