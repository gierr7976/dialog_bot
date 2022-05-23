part of dialog_bot.home.view;

class BackPoint extends MenuPoint {
  static const String kName = 'back';

  static const String kButton = 'Назад';

  @override
  KeyboardButton get button => KeyboardButton(text: kButton);

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
