part of dialog_bot.auth.view;

class Sentinel extends FlowPoint with UserScopeProvider {
  @override
  String get name => 'sentinel';

  final FlowPoint onAuthenticated;

  final FlowPoint onUnauthenticated;

  Sentinel({
    required this.onAuthenticated,
    required this.onUnauthenticated,
  });

  @override
  FutureOr<void> pass() async {
    final UserScope scope = await getUserScope();
    await scope.checkout(message.from!.id);
    navigator.store(scope);

    if (scope.authenticated) return await navigator.next(onAuthenticated);

    await navigator.next(onUnauthenticated);
  }
}
