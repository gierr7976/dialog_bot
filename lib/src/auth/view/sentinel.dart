part of dialog_bot.auth.view;

class Sentinel extends FlowPoint with UserScopeProvider {
  @override
  String get name => 'sentinel';

  final RouteBuilder onAuthenticated;

  final RouteBuilder onUnauthenticated;

  Sentinel({
    required this.onAuthenticated,
    required this.onUnauthenticated,
  });

  @override
  FutureOr<void> pass() async {
    final UserScope scope = await getUserScope();
    await scope.checkout(message.from!.id);

    if (scope.authenticated)
      return await navigator.next(
        onAuthenticated(),
      );

    await navigator.next(
      onUnauthenticated(),
    );
  }
}
