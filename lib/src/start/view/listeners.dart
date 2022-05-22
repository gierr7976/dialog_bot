part of dialog_bot.start.view;

class StartListener extends AuthenticatedListener {
  @override
  List<Stream<TeleDartMessage>> on(TeleDart tg) => [
        tg.onCommand('start'),
      ];

  @override
  FlowPoint onAuthenticated() => WelcomePoint(
        next: () => AuthenticatedPoint(),
      );

  @override
  FlowPoint onUnauthenticated() => DeeplinkPoint(
        map: {
          VerifyPoint.kName: () => VerifyPoint(),
        },
        plain: () => UnauthenticatedPoint(),
      );
}

class LetsGoListener extends AuthenticatedListener {
  static const String message = 'Поехали \u{1F680}';

  @override
  List<Stream<TeleDartMessage>> on(TeleDart tg) => [
        tg.onMessage(keyword: message),
      ];

  @override
  FlowPoint onAuthenticated() => TodoPoint();

  @override
  FlowPoint onUnauthenticated() => EndPoint();
}
