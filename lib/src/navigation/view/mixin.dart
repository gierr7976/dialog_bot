part of dialog_bot.navigation.view;

mixin VisitorScopeProvider {
  Future<VisitorScope> visitorScopeFrom(Navigator navigator) async {
    final VisitorScope? stored = navigator.ready.prefer();

    if (stored is VisitorScope) return stored;

    final VisitorScope scope = VisitorScope();
    await scope.init();

    return scope;
  }
}
