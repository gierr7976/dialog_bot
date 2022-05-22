part of dialog_bot.navigation.view;

typedef RouteBuilder = FlowPoint Function();

class Router extends FlowPoint with VisitorScopeProvider {
  @override
  final String name = 'router';

  final String preferred;

  final Map<String, RouteBuilder> routes;

  Router({
    this.preferred = BotConfig.home_route,
    required this.routes,
  }) : assert(
          routes.containsKey(preferred),
          'Preferred not exists',
        );

  @override
  FutureOr<void> pass() async {
    final VisitorScope scope = await getVisitorScope();

    await scope.checkout(message.from!.id);

    final String storedRoute = scope.ready.route;
    final bool routeExists = routes.containsKey(storedRoute);

    if (routeExists)
      return navigator.next(
        routes[storedRoute]!(),
      );

    await scope.next(preferred);

    return navigator.next(
      routes[preferred]!(),
    );
  }
}
