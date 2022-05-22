part of dialog_bot.auth.repo;

abstract class UserRepository implements VisitorRepository {
  bool get allowUnauthorizedRouting;

  Future<BotUser?> fetchUser(int id);

  Future<BotUser?> fetchByCode(String code);

  @override
  Future<void> create(covariant BotUser user);

  Future<void> update(BotUser user);
}
