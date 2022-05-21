part of dialog_bot.navigation.usecase;

class VisitorState {
  final Visitor visitor;

  String get route => visitor.route;

  const VisitorState({
    required this.visitor,
  });

  VisitorState copyWith({
    Visitor? visitor,
  }) =>
      VisitorState(
        visitor: visitor ?? this.visitor,
      );
}

class VisitorScope extends Cubit<VisitorState?> {
  late final VisitorRepository _repository;

  VisitorState get ready => state!;

  VisitorScope() : super(null);

  Future<void> init() async => _repository = await GetIt.instance.getAsync();

  @mustCallSuper
  Future<Visitor> checkout(int id) async {
    Visitor? visitor = await _repository.fetch(id);

    return visitor ?? _getFallbackVisitor(id);
  }

  @mustCallSuper
  FutureOr<void> next(String route) async => emit(
        ready.copyWith(
          visitor: ready.visitor.copyWith(
            route: route,
          ),
        ),
      );

  Future<void> saveRoute() async => _repository.updateRoute(ready.visitor);

  Visitor _getFallbackVisitor(int id) => Visitor(
        key: ObjectId(),
        id: id,
      );
}
