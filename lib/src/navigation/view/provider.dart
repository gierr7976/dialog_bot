part of dialog_bot.navigation.view;

mixin VisitorScopeProvider on FlowPoint {
  Future<VisitorScope> getVisitorScope() async {
    final VisitorScope? stored = navigator.ready.prefer();

    if (stored is VisitorScope) return stored;

    final VisitorScope scope = VisitorScope();
    await scope.init();

    return scope;
  }
}
