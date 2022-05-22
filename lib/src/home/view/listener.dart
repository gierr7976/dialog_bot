part of dialog_bot.home.view;

class HomeListener extends AuthenticatedListener {
  static const String command = 'home';

  @override
  List<Stream<TeleDartMessage>> on(TeleDart tg) => [
        tg.onCommand(command),
        tg.onMessage(keyword: ShowsPoint.kButton),
        tg.onMessage(keyword: ClassesPoint.kButton),
      ];

  @override
  FlowPoint onAuthenticated() => Forwarder(
        routes: {
          HomePoint.kName: () => HomePoint(),
          ShowsPoint.kButton: () => ShowsPoint(),
          ClassesPoint.kButton: () => ClassesPoint(),
        },
      );

  @override
  FlowPoint onUnauthenticated() => EndPoint();
}
