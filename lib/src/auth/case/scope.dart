part of dialog_bot.auth.usecase;

class UserScope extends VisitorScope {
  late final UserRepository _repository;

  bool get authenticated => state is BotUser;

  @override
  BotUser get ready => super.ready as BotUser;

  @override
  Future<void> init() async {
    _repository = await GetIt.instance.getAsync();

    return super.init();
  }

  @override
  Future<void> checkout(int id) async {
    final BotUser? user = await _repository.fetchUser(id);

    if (user is BotUser) emit(user);
  }
}
