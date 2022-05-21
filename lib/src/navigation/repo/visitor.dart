part of dialog_bot.navigation.repo;

abstract class VisitorRepository {
  Future<Visitor?> fetch(int id);

  Future<void> create(Visitor visitor);

  Future<void> updateRoute(Visitor visitor);
}
