part of dialog_bot.start.view;

class WelcomePoint extends FlowPoint {
  final RouteBuilder next;

  WelcomePoint({
    required this.next,
  });

  @override
  String get name => 'welcome';

  @override
  FutureOr<void> pass() async {
    final String username = message.from?.first_name ?? 'незнакомец';

    await message.reply(
      'Привет, $username!',
      reply_markup: ReplyKeyboardRemove(
        remove_keyboard: true,
        selective: false,
      ),
    );

    await navigator.next(
      next(),
    );
  }
}

class AuthenticatedPoint extends FlowPoint with Stored {
  @override
  String get name => 'auth/yes';

  @override
  FutureOr<void> pass() async {
    final Delayer delayer = Delayer(
      delayed: [
        () => message.reply(_emoji),
        () => message.reply(
              _goodToSee,
              parse_mode: 'MarkdownV2',
            ),
        () => message.reply(
              _letsStart,
              reply_markup: _letsStartMarkup,
            ),
      ],
    );

    await delayer.start();
  }

  static const String _emoji = '\u270C';

  static const String _goodToSee = //
      'Рад тебя видеть\\!\n'
      '\n'
      'Я — бот "Нового Диалога"\\.\n'
      'Я подскажу тебе, где и когда будет репетиция, спектакль ~и бухло~, '
      'помогу найти нужный реквизит и\\.\\.\\.\n'
      '\n'
      'В общем, не дам пропасть '
      'твоему актёрскому таланту \u{1F609}';

  static const String _letsStart = 'Ну что, начнём?';

  final ReplyMarkup _letsStartMarkup = ReplyKeyboardMarkup(
    keyboard: [
      [
        KeyboardButton(
          text: LetsGoListener.message,
        ),
      ],
    ],
    resize_keyboard: true,
    one_time_keyboard: true,
  );
}

class UnauthenticatedPoint extends FlowPoint {
  @override
  String get name => 'auth/no';

  @override
  FutureOr<void> pass() async {
    await message.reply(_reply);

    navigator.finish();
  }

  String get _reply => //
      '\u26D4 Стоп!\n'
      '\n'
      'Прежде чем пользоваться ботом, тебе нужно зарегистрироваться.\n'
      '\n'
      'Попроси у администратора приглашение или воспользуйся им, '
      'если оно у тебя уже есть';
}
