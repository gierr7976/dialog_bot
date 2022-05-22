part of dialog_bot.start.view;

class StartListener extends AuthenticatedListener {
  static const String command = 'start';

  @override
  List<Stream<TeleDartMessage>> on(TeleDart tg) => [
        tg.onCommand(command),
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
  FlowPoint onAuthenticated() => Router(
        routes: {
          HomePoint.kName: () => HomePoint(),
        },
      );

  @override
  FlowPoint onUnauthenticated() => EndPoint();
}
