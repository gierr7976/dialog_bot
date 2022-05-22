part of dialog_bot.home.view;

class HomePoint extends MenuPoint {
  static const String kName = 'home';

  @override
  String get name => kName;

  @override
  String get button => throw UnsupportedError('Root menu');

  @override
  ReplyKeyboardMarkup keyboard(BotUser user) => ReplyKeyboardMarkup(
        keyboard: [
          [
            KeyboardButton(text: ShowsPoint.kButton),
            KeyboardButton(text: ClassesPoint.kButton),
          ],
        ],
        one_time_keyboard: true,
        resize_keyboard: true,
      );

  @override
  FutureOr<void> forUser(BotUser user) => message.reply(
        _account(user),
        parse_mode: 'MarkdownV2',
        reply_markup: keyboard(user),
      );

  String _account(BotUser user) => //
      '**${user.fullName}**\n'
      '\n'
      '\u{1F4D6} 0  ' // Постановок
      '\u{1F3AD} 0  ' // Спектаклей
      '\u{1F60E} 0  ' // Был на репах
      '\u{1F4A9} 0\n'; // Проебал реп
}
