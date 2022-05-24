part of dialog_bot.core.view;

class FlowNavigatorState {
  final Visitor visitor;

  final List<dynamic> _data;

  final FlowPoint _current;

  const FlowNavigatorState._({
    required this.visitor,
    required List<dynamic> data,
    required FlowPoint current,
  })  : _data = data,
        _current = current;

  T? prefer<T>() => _data.firstWhere(
        (element) => element is T,
        orElse: () => null,
      );

  T require<T>() => prefer()!;

  FlowNavigatorState _copyWith({
    Visitor? visitor,
    List<dynamic>? data,
    FlowPoint? current,
  }) =>
      FlowNavigatorState._(
        visitor: visitor ?? this.visitor,
        data: data ?? _data,
        current: current ?? _current,
      );
}

class FlowNavigator extends Cubit<FlowNavigatorState?> {
  final TeleDart tg;

  final TeleDartMessage message;

  final Input trigger;

  final List<FlowPoint> _roots;

  late final VisitorRepository _repository;

  FlowNavigatorState get ready => state!;

  FlowNavigator({
    required this.tg,
    required this.message,
    required this.trigger,
    required List<FlowPoint> roots,
  })  : assert(roots.isNotEmpty),
        _roots = roots,
        super(null);

  Future<void> init() async {
    assert(state == null);

    _repository = await GetIt.instance.getAsync();

    final int id = message.from!.id;
    final Visitor visitor = await _repository.fetch(id) ??
        Visitor.create(
          id: id,
          route: Uri.parse(BotConfig.home_route),
        );

    final FlowPoint from = trigger is CommandInput
        ? _findCommand(trigger as CommandInput)
        : _FlowExplorer(_roots).find(visitor.route)!;

    emit(
      FlowNavigatorState._(
        visitor: visitor,
        data: [],
        current: from,
      ),
    );
  }

  Future<void> run() async {
    await init();

    FlowPoint next = ready._current;

    while (true) {
      final String? requested = await next.handle(this);

      if (requested is String) {
        if (requested[0] == '/')
          next = _nextGlobal(requested);
        else
          next = _nextLocal(requested);
      } else
        break;

      if (next.shouldStore) await _repository.store(ready.visitor);
    }
  }

  //<editor-fold desc="Next point getters">

  FlowPoint _nextGlobal(String next) {
    final Uri route = Uri.parse(next);

    final FlowPoint nextPoint = _FlowExplorer(_roots).find(route)!;

    emit(
      ready._copyWith(
        visitor: ready.visitor.copyWith(route: route),
        current: nextPoint,
      ),
    );

    return nextPoint;
  }

  FlowPoint _nextLocal(String next) {
    final Uri route = Uri.parse(
      '/${[...ready.visitor.route.pathSegments, next].join('/')}',
    );
    final Uri routeLocal = Uri.parse('/$next');

    final FlowPoint nextPoint =
        _FlowExplorer(ready._current.build()!).find(routeLocal)!;

    emit(
      ready._copyWith(
        visitor: ready.visitor.copyWith(route: route),
        current: nextPoint,
      ),
    );

    return nextPoint;
  }

  FlowPoint _findCommand(CommandInput trigger) =>
      _FlowExplorer(_roots)._findInline(trigger.command, _roots)!;

//</editor-fold>
}
