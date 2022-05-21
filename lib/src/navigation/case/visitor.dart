part of dialog_bot.navigation.usecase;

class VisitorScope extends Cubit<Visitor?> {
  @protected
  late final VisitorRepository _repository;

  Visitor get ready => state!;

  VisitorScope() : super(null);

  Future<void> init() async => _repository = await GetIt.instance.getAsync();

  Future<void> checkout(int id) async {
    Visitor? visitor = await _repository.fetch(id);

    emit(
      visitor ?? _getFallbackVisitor(id),
    );
  }

  FutureOr<void> next(String route) async {
    final Visitor visitor = ready.copyWith(route: route);

    await _repository.updateRoute(visitor);

    emit(visitor);
  }

  Visitor _getFallbackVisitor(int id) => Visitor(
        key: ObjectId(),
        id: id,
      );
}
