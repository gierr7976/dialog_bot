part of dialog_bot.collective.view;

class CollectivePoint extends MenuPoint {
  static const String kName = 'collective';
  static const String kButton = '${Emoji.kasper} Коллектив';

  @override
  String get name => kName;

  @override
  String get button => kButton;

  @override
  FutureOr<void> forUser(BotUser user) async {
    final CollectiveService service = CollectiveService();
    await service.init();

    List<BotUser> users = await service.all(user);

    await message.reply(
      _reply(users),
      parse_mode: 'MarkdownV2',
    );

    navigator.finish();
  }

  @override
  ReplyMarkup keyboard(BotUser user) {
    // TODO: implement keyboard
    throw UnimplementedError();
  }

  String _reply(List<BotUser> users) => //
      '**Коллектив "Нового Диалога":**\n'
      '\n'
      '${_userList(users)}';

  String _userList(List<BotUser> users) {
    String result = '';

    for (int i = 0; i < users.length; i++) {
      final BotUser user = users[i];

      final String linked = '[${user.fullName}](tg://user?id=${user.id})';

      result += '${i + 1}\\.  $linked';
    }

    return result;
  }
}
