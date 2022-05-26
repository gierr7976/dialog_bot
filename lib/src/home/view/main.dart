part of dialog_bot.home.view;

class HomePoint extends FlowPoint with Keyboard {
  @override
  final String name = 'home';

  @override
  final bool shouldStore = true;

  @override
  List<FlowPoint> get children => [
        HomeHelpPoint(),
        TodoButton(
          name: 'classes',
          text: '${Emoji.pin} Репетиции',
          next: '/home',
        ),
        TodoButton(
          name: 'scenarios',
          text: '${Emoji.book} Постановки',
          next: '/home',
        ),
        RedirectButton(
          name: 'collective',
          text: '${Emoji.kasper} Коллектив',
          next: '/collective',
        ),
        TodoButton(
          name: 'notify',
          text: '${Emoji.fire} Оповестить',
          next: '/home',
        ),
      ];

  @override
  FutureOr<String?> handle(FlowNavigator navigator) async {
    await navigator.message.reply(
      _account(navigator.user!),
      parse_mode: 'MarkdownV2',
      reply_markup: getKeyboard(navigator.user),
    );

    return null;
  }

  String _account(DialogUser user) => //
      '**${user.fullName}**\n'
      '\n'
      '${_membership(user)}'
      '\n'
      '\n'
      '${_stats(user)}';

  String _membership(DialogUser user) => //
      '${Emoji.book} **В составе постановок:**\n'
      '\n'
      '${'  ' * 5}_\\[TODO\\]_\n';

  String _stats(DialogUser user) => //
      '${Emoji.book} 0  ' // Постановок
      '${Emoji.masks} 0  ' // Спектаклей
      '${Emoji.sunglasses} 0  ' // Был на репах
      '${Emoji.poo} 0\n'; // Проебал реп
}

class HomeHelpPoint extends FlowPoint {
  @override
  final String name = 'help';

  @override
  FutureOr<String?> handle(FlowNavigator navigator) async {
    final Delayer delayer = Delayer(
      delayed: [
        () => navigator.message.reply(_positions),
        () => navigator.message.reply(_scenarios),
        () => navigator.message.reply(_stats),
      ],
      delay: Duration(seconds: 2),
    );

    await delayer.run();

    return '/home';
  }

  static const _positions = //
      'В первую очередь, ты увидишь свои обязанности.\n'
      '\n'
      'Подробнее о них можно узнать здесь: !тык!'; // TODO: add link

  static const _scenarios = //
      'Во-вторых, ты увидишь постановки, в которых участвуешь.\n'
      '\n'
      'Подробности — в меню профиля.';

  static const _stats = //
      'И, наконец, в-третьих, ты увидишь свою статистику.\n'
      '\n'
      '${Emoji.book} — твои прошлые и текущие постановки\n'
      '${Emoji.masks} — твои прошлые выступления\n'
      '\n'
      '${Emoji.sunglasses} — посещённые тобой репетиции\n'
      '${Emoji.poo} — прогулянные тобой репетиции';
}
