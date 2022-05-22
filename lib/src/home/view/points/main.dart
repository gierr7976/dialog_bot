part of dialog_bot.home.view;

class HomePoint extends FlowPoint with Stored {
  static const String kName = 'home';

  @override
  String get name => kName;

  @override
  FutureOr<void> pass() async {
    final UserScope scope = navigator.ready.require();
    final BotUser user = scope.ready;

    await message.reply(
      _account(user),
      parse_mode: 'MarkdownV2',
      reply_markup: _keyboard(user),
    );
  }

  String _account(BotUser user) => //
      '**${user.fullName}**\n'
      '\n'
      '\u{1F4D6} 0  '
      '\u{1F3AD} 0  '
      '\u{1F60E} 0  '
      '\u{1F4A9} 0\n';

  ReplyKeyboardMarkup _keyboard(BotUser user) => ReplyKeyboardMarkup(
        keyboard: [
          [
            KeyboardButton(text: ShowsPoint.kButton),
            KeyboardButton(text: ClassesPoint.kButton),
          ],
        ],
        one_time_keyboard: true,
        resize_keyboard: true,
      );
}
