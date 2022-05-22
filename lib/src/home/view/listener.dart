part of dialog_bot.home.view;

class HomeListener extends AuthenticatedListener {
  static const String command = 'home';

  List<MenuPoint> get points => [
        HomePoint(),
        ShowsPoint(),
        ClassesPoint(),
        UsersPoint(),
      ];

  @override
  List<Stream<TeleDartMessage>> on(TeleDart tg) => [
        for (MenuPoint point in points)
          point is HomePoint
              ? tg.onCommand(point.name)
              : tg.onMessage(keyword: point.button),
      ];

  @override
  FlowPoint get onAuthenticated => Forwarder(
        routes: routes,
      );

  Map<String, MenuPoint> get routes {
    final Map<String, MenuPoint> result = {};

    for (MenuPoint point in points) {
      final String key = point is HomePoint ? point.name : point.button;

      result[key] = point;
    }

    return result;
  }

  @override
  FlowPoint get onUnauthenticated => EndPoint();
}
