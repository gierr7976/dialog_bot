part of dialog_bot.common.view;

class TodoButton extends RedirectButton {
  TodoButton({
    required super.name,
    required super.text,
    String? next,
  }) : super(
          children: [
            _TodoPoint(next: next),
          ],
          next: 'todo',
        );
}

class _TodoPoint extends FlowPoint {
  @override
  String get name => 'todo';

  final String? next;

  _TodoPoint({
    this.next,
  });

  @override
  FutureOr<String?> handle(FlowNavigator navigator) async {
    final Delayer delayer = Delayer(
      delayed: [
        () => navigator.message.reply(Emoji.reverted),
        () => navigator.message.reply(_reply),
      ],
      delay: Duration(seconds: 1),
    );

    await delayer.run();

    return next;
  }

  static const String _reply = //
      'Ой!\n'
      '\n'
      'Я только учусь выполнять эту команду, '
      'давай попробуем позже?';
}
