part of dialog_bot.user.repo;

abstract class UserRepository implements VisitorRepository {
  @override
  Future<DialogUser?> fetch(int id);

  Future<DialogUser?> fetchByCode(String code);

  @override
  Future<void> store(covariant DialogUser user);
}
