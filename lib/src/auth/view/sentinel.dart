part of dialog_bot.auth.view;

class Sentinel extends FlowPoint with UserScopeProvider {
  @override
  String get name => 'sentinel';

  final RouteBuilder onAuthorized;

  final RouteBuilder onUnauthorized;

  Sentinel({
    required this.onAuthorized,
    required this.onUnauthorized,
  });

  @override
  FutureOr<void> pass() async {
    final UserScope scope = await getUserScope();
    await scope.checkout(message.from!.id);

    if (scope.authenticated)
      return await navigator.next(
        onAuthorized(),
      );

    await navigator.next(
      onUnauthorized(),
    );
  }
}
