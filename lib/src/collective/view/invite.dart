part of dialog_bot.collective.view;

class _InvitePoint extends SecureInputPoint with Keyboard {
  @override
  final String name = 'invite';

  @override
  final bool shouldStore = true;

  @override
  Input get trigger => PermittedButtonInput(
        name: name,
        text: '${Emoji.hello} Пригласить',
        permission: Permission.invite,
      );

  @override
  List<FlowPoint> get children => [
        RedirectButton(
          name: 'back',
          text: 'Назад',
          next: '/collective',
        ),
        _NamePoint(),
      ];

  @override
  FutureOr<String?> onAuthorized(FlowNavigator navigator) async {
    await navigator.message.reply(
      _reply,
      reply_markup: getKeyboard(navigator.user),
    );

    return null;
  }

  static const String _reply = //
      'Кого ты хочешь пригласить?\n'
      '\n'
      'Отправь имя и фамилию';
}

class _NamePoint extends SecureInputPoint {
  static const kPattern = r'[А-Я][а-я]* [А-Я][а-я]*';

  @override
  final String name = 'name-input';

  @override
  Input get trigger => TextInput(
        name: name,
        pattern: RegExp(kPattern),
      );

  @override
  FutureOr<String?> onAuthorized(FlowNavigator navigator) async {
    final String? fullName =
        RegExp(kPattern).firstMatch(navigator.message.text ?? '')?[0];

    if (fullName is String) {
      final Inviter inviter = Inviter();
      await inviter.init();

      final Invite invite = await inviter.invite(fullName);

      await navigator.message.reply(_resend);
      await navigator.message.reply(
        _link(invite),
      );

      return '/collective';
    }

    return '/collective/invite';
  }

  static const String _resend = //
      'Перешли это сообщение человеку, которого хочешь пригласить:';

  String _link(Invite invite) => //
      'Чтобы начать пользоваться ботом, нажми на эту ссылку:\n'
      '\n'
      '${BotConfig.bot_link}?start=signup-${invite.code}';
}
