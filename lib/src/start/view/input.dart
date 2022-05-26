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
        SignupPoint(),
      ];

  final List<DeeplinkForwarder> public;

  final List<DeeplinkForwarder> private;

  const StartCommand({
    this.public = const [],
    this.private = const [],
  });

  @override
  FutureOr<String?> handle(FlowNavigator navigator) {
    for (DeeplinkForwarder forwarder in public)
      if (forwarder.matching(navigator.message.text ?? ''))
        return forwarder.next;

    return super.handle(navigator);
  }

  @override
  FutureOr<String?> onAuthorized(FlowNavigator navigator) =>
      _handleDeeplink(
        navigator,
        [
          ...public,
          ...private,
        ],
      ) ??
      'authenticated';

  @override
  FutureOr<String?> onNonAuthorized(FlowNavigator navigator) =>
      _handleDeeplink(navigator, public) ?? 'non-authenticated';

  String? _handleDeeplink(
    FlowNavigator navigator,
    List<DeeplinkForwarder> deeplinks,
  ) {
    for (DeeplinkForwarder forwarder in deeplinks)
      if (forwarder.matching(navigator.message.text ?? ''))
        return forwarder.next;

    return null;
  }
}
