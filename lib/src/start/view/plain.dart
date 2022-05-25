part of dialog_bot.start.view;

class _StartAuthenticated extends FlowPoint with Keyboard {
  @override
  String get name => 'authenticated';

  @override
  final bool shouldStore = true;

  @override
  List<FlowPoint>? build() => [
        _LetsGoButtonPoint(),
      ];

  @override
  FutureOr<String?> handle(FlowNavigator navigator) async {
    final Delayer delayer = Delayer(
      delayed: [
        () => navigator.message.reply(Emoji.victory),
        () => navigator.message.reply(
              _goodToSee,
              parse_mode: 'MarkdownV2',
            ),
        () => navigator.message.reply(
              _letsStart,
              reply_markup: getKeyboard(navigator.user),
            ),
      ],
    );

    await delayer.start();

    return null;
  }

  static const String _goodToSee = //
      'Рад тебя видеть\\!\n'
      '\n'
      'Я — бот "Нового Диалога"\\.\n'
      'Я подскажу тебе, где и когда будет репетиция, спектакль ~и бухло~, '
      'помогу найти нужный реквизит и\\.\\.\\.\n'
      '\n'
      'В общем, не дам пропасть '
      'твоему актёрскому таланту ${Emoji.winky}';

  static const String _letsStart = 'Ну что, начнём?';
}

class _LetsGoButtonPoint extends SecureInputPoint {
  static const String button = 'Поехали ${Emoji.rocket}';

  @override
  String get name => 'lets-go';

  @override
  FutureOr<String?> onAuthorized(FlowNavigator navigator) => null;

  @override
  Input get trigger => PermittedButtonInput(
        name: name,
        text: button,
      );
}

class _StartNonAuthenticated extends FlowPoint with Keyboard {
  @override
  String get name => 'non-authenticated';

  @override
  FutureOr<String?> handle(FlowNavigator navigator) async {
    await navigator.message.reply(Emoji.stop);

    await navigator.message.reply(
      _reply,
      reply_markup: getKeyboard(null),
    );

    return null;
  }

  static const String _reply = //
      'Стоп!\n'
      '\n'
      'Прежде чем пользоваться ботом, тебе нужно зарегистрироваться.\n'
      '\n'
      'Попроси у администратора приглашение или воспользуйся им, '
      'если оно у тебя уже есть';
}
