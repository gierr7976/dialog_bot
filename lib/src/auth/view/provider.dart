part of dialog_bot.auth.view;

mixin UserScopeProvider on FlowPoint {
  Future<UserScope> getUserScope() async {
    final UserScope? stored = navigator.ready.prefer();

    if (stored is UserScope) return stored;

    final UserScope scope = UserScope();
    await scope.init();

    return scope;
  }
}
