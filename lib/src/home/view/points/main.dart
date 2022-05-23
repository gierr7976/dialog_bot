part of dialog_bot.home.view;

class HomePoint extends MenuPoint {
  static const String kName = 'home';

  @override
  String get name => kName;

  @override
  KeyboardButton get button => throw UnsupportedError('Root menu');

  @override
  ReplyMarkup keyboard(BotUser user) => MenuKeyboard(
        targets: [
          ShowsPoint(),
          ClassesPoint(),
          CollectivePoint(),
          NotificationPoint(),
        ],
      ).markup;

  @override
  FutureOr<void> forUser(BotUser user) => message.reply(
        _account(user),
        parse_mode: 'MarkdownV2',
        reply_markup: keyboard(user),
      );

  String _account(BotUser user) => //
      '**${user.fullName}**\n'
      '\n'
      '${_membership(user)}'
      '\n'
      '\n'
      '${_stats(user)}';

  String _membership(BotUser user) => //
      '${Emoji.book} **В составе постановок:**\n'
      '\n'
      '${'  ' * 5}_\\[TODO\\]_\n';

  String _stats(BotUser user) => //
      '${Emoji.book} 0  ' // Постановок
      '${Emoji.masks} 0  ' // Спектаклей
      '${Emoji.sunglasses} 0  ' // Был на репах
      '${Emoji.poo} 0\n'; // Проебал реп
}
