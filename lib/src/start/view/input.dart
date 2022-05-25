part of dialog_bot.start.view;

class StartCommand extends SecureInputPoint {
  @override
  String get name => 'start';

  @override
  Input get trigger => CommandInput(
        command: 'start',
        description: 'Запускает бота',
      );

  @override
  List<FlowPoint>? build() => [
        _StartAuthenticated(),
        _StartNonAuthenticated(),
      ];

  @override
  FutureOr<String?> onAuthorized(FlowNavigator navigator) async =>
      'start/authenticated';

  @override
  FutureOr<String?> onNonAuthorized(FlowNavigator navigator) async =>
      'start/non-authenticated';
}
