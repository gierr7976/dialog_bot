part of dialog_bot.home.view;

class ShowsPoint extends MenuPoint {
  static const String kName = 'home/shows';
  static const String kButton = '${Emoji.book} Постановки';

  @override
  String get name => kName;

  @override
  KeyboardButton get button => KeyboardButton(text: kButton);

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
