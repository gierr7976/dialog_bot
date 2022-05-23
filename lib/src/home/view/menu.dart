part of dialog_bot.home.view;

abstract class MenuPoint extends FlowPoint with Stored {
  String get button;

  @override
  FutureOr<void> pass() async {
    final UserScope scope = navigator.ready.require();
    final BotUser user = scope.ready;

    if (scope.authenticated) return forUser(user);

    navigator.finish();
  }

  FutureOr<void> forUser(BotUser user);

  ReplyMarkup keyboard(BotUser user);
}

class BackPoint extends MenuPoint {
  static KeyboardButton buildButton() => KeyboardButton(text: kButton);

  static const String kName = 'back';

  static const String kButton = 'Назад';

  @override
  String get button => kButton;

  @override
  String get name => kName;

  final FlowPoint preferred;

  final Map<String, FlowPoint> routes;

  BackPoint({
    required this.preferred,
    this.routes = const {},
  });

  @override
  FutureOr<void> forUser(BotUser user) {
    final String route = user.route;

    return navigator.next(routes[route] ?? preferred);
  }

  @override
  ReplyMarkup keyboard(BotUser user) =>
      throw UnsupportedError('BackPoint should not have keyboard');
}
