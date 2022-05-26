part of dialog_bot.collective.view;

class CollectivePoint extends FlowPoint with Keyboard {
  @override
  final String name = 'collective';

  @override
  final bool shouldStore = true;

  @override
  List<FlowPoint> get children => [
        _InvitePoint(),
        RedirectButton(
          name: 'back',
          text: 'Назад',
          next: '/home',
        ),
      ];

  @override
  FutureOr<String?> handle(FlowNavigator navigator) async {
    await navigator.message.reply(
      _overview(navigator.user),
      reply_markup: getKeyboard(navigator.user),
    );

    return null;
  }

  String _overview(DialogUser? user) => '[TODO]';
}
