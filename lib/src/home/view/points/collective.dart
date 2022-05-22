part of dialog_bot.home.view;

class CollectivePoint extends MenuPoint {
  static const String kName = 'home/collective';
  static const String kButton = '${Emoji.kasper} Команда';

  @override
  String get name => kName;

  @override
  String get button => kButton;

  @override
  FutureOr<void> forUser(BotUser user) => navigator.next(
        TodoPoint(
          next: HomePoint(),
        ),
      );

  @override
  ReplyMarkup keyboard(BotUser user) {
    // TODO: implement keyboard
    throw UnimplementedError();
  }
}
