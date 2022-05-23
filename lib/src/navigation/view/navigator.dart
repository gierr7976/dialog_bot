part of dialog_bot.navigation.view;

mixin Stored on FlowPoint {
  bool get isPreservable => true;
}

@Injectable(as: Navigator)
class VisitorNavigator extends Navigator {
  @override
  Future<void> next(FlowPoint point) async {
    await updateRoute(point);

    return super.next(point);
  }

  Future<void> updateRoute(FlowPoint point) async {
    final VisitorScope? scope = state?.prefer();

    if (scope is VisitorScope && point is Stored && point.isPreservable)
      await scope.next(point.name);
  }
}
