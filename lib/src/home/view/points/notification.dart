part of dialog_bot.home.view;

class NotificationPoint extends MenuPoint {
  static const String kName = 'notification';
  static const String kButton = '${Emoji.fire} Оповестить';

  @override
  String get name => kName;

  @override
  String get button => kButton;

  FlowPoint get fallback => HomePoint();

  @override
  FutureOr<void> forUser(BotUser user) => navigator.next(
        TodoPoint(next: fallback),
      );

  @override
  ReplyMarkup keyboard(BotUser user) {
    // TODO: implement keyboard
    throw UnimplementedError();
  }
}
