part of dialog_bot.collective.usecase;

class CollectiveService {
  late final CollectiveRepository _repository;

  Future<void> init() async {
    _repository = await GetIt.instance.getAsync();
  }

  Future<List<BotUser>> all(BotUser by) async {
    if (by.isRegistered) {
      final List<BotUser> users = await _repository.all();

      return users;
    }

    throw StateError('Forbidden');
  }
}
