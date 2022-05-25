part of dialog_bot.core.view;

class FlowNavigatorState {
  final Visitor visitor;

  final FlowPoint _current;

  final List<dynamic> _data;

  const FlowNavigatorState({
    required this.visitor,
    required FlowPoint current,
    List<dynamic> data = const [],
  })  : _current = current,
        _data = data;

  T? prefer<T>() => _data.firstWhere(
        (stored) => stored is T,
        orElse: () => null,
      );

  T require<T>() => prefer()!;

  FlowNavigatorState copyWith({
    Visitor? visitor,
    FlowPoint? current,
    List<dynamic>? data,
  }) =>
      FlowNavigatorState(
        visitor: visitor ?? this.visitor,
        current: current ?? _current,
        data: data ?? _data,
      );
}

class FlowNavigator extends Cubit<FlowNavigatorState?> {
  final TeleDart tg;

  final TeleDartMessage message;

  final InputScope scope;

  final RootPoint _root;

  late final VisitorRepository _repository;

  FlowNavigatorState get ready => state!;

  Uri get home => Uri.parse(BotConfig.home_route);

  @visibleForTesting
  FlowNavigator({
    required this.tg,
    required this.message,
    required RootPoint root,
    required this.scope,
  })  : _root = root,
        super(null);

  Future<void> _init() async {
    _repository = await GetIt.instance.getAsync();

    final Visitor visitor = await //
        _repository.fetch(message.from!.id) ??
        Visitor.create(id: message.from!.id);

    final Uri from =
        scope.match(visitor.route) ?? scope.global ?? visitor.route;

    final FlowPoint first = _byRoute(from);

    emit(
      FlowNavigatorState(
        visitor: visitor.copyWith(
          route: from,
        ),
        current: first,
      ),
    );
  }

  Future<void> run() async {
    await _init();

    _logStart(ready.visitor.route);

    FlowPoint current = ready._current;

    while (true) {
      final String? next = await current.handle(this);

      if (next is String) {
        assert(next[0] == '/');

        final Uri nextRoute = Uri.parse(next);
        final FlowPoint? nextPoint = _bySegments(nextRoute.pathSegments, _root);

        if (nextPoint is FlowPoint) {
          current = nextPoint;
          emit(
            ready.copyWith(
              visitor: ready.visitor.copyWith(route: nextRoute),
              current: current,
            ),
          );

          _logTransition(nextRoute);
        } else
          throw ArgumentError('Route not exists');
      } else
        break;

      if (ready._current.shouldStore) await _repository.store(ready.visitor);
    }

    _logEnd(ready.visitor.route);

    await close();
  }

  //<editor-fold desc="Storage methods">

  void store<T>(T element) {
    final List<dynamic> data = ready._data.toList();
    data.removeWhere((element) => element is T);
    data.add(element);

    emit(
      ready.copyWith(
        data: data,
      ),
    );
  }

  T? prefer<T>() => ready.prefer();

  T require<T>() => ready.require();

  //</editor-fold>

  void updateVisitor(Visitor visitor) {
    final bool isVisitorModified = visitor.id != state?.visitor.id;

    final bool isRouteModified = visitor.route != state?.visitor.route;

    final bool shouldHandle = !isVisitorModified && !isRouteModified;

    if (shouldHandle)
      return emit(
        ready.copyWith(
          visitor: visitor,
        ),
      );

    slLogger.w('Route and id should not be modified outside of FlowNavigator');
  }

  //<editor-fold desc="Routing">

  FlowPoint _byRoute(Uri route) =>
      _bySegments(route.pathSegments, _root) ??
      _bySegments(home.pathSegments, _root)!;

  FlowPoint? _bySegments(List<String> segments, FlowPoint point) {
    if (segments.length == 1 && point is! RootPoint)
      return _alignSegment(segments.first, point);

    for (FlowPoint sub in point.build() ?? []) {
      final List<String> subsegments =
          point is RootPoint ? segments : segments.sublist(1);

      if (sub.name == subsegments.first) return _bySegments(subsegments, sub);
    }

    return null;
  }

  FlowPoint? _alignSegment(String segment, FlowPoint point) =>
      point.name == segment ? point : null;

//</editor-fold>

  //<editor-fold desc="Logging">

  void _logStart(Uri route) => slLogger.v(
        '${message.from?.debugName} started on ${route.toString()}',
      );

  void _logTransition(Uri route) => slLogger.v(
        '${message.from?.debugName} forwarded to ${route.toString()}',
      );

  void _logEnd(Uri route) => slLogger.v(
        '${message.from?.debugName} finished on ${route.toString()}',
      );

//</editor-fold>
}
