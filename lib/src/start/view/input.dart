part of dialog_bot.start.view;

class StartCommand extends SecureInputPoint {
  @override
  String get name => 'start';

  @override
  Input get trigger => CommandInput(
        command: 'start',
        description: 'Запустить бота',
      );

  @override
  List<FlowPoint> get children => [
        _StartAuthenticated(),
        _StartNonAuthenticated(),
      ];

  @override
  FutureOr<String?> onAuthorized(FlowNavigator navigator) async =>
      'authenticated';

  @override
  FutureOr<String?> onNonAuthorized(FlowNavigator navigator) async =>
      'non-authenticated';
}
