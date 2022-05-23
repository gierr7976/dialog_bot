part of dialog_bot.collective.view;

class InvitePoint extends MenuPoint {
  static const String kButton = '${Emoji.hello} Пригласить';

  @override
  String get name => 'collective/invite';

  @override
  KeyboardButton get button => KeyboardButton(text: kButton);

  @override
  FutureOr<void> forUser(BotUser user) => navigator.next(
        TodoPoint(
          next: CollectivePoint(),
        ),
      );

  @override
  ReplyMarkup keyboard(BotUser user) {
    // TODO: implement keyboard
    throw UnimplementedError();
  }
}
