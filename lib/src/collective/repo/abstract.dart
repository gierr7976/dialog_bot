part of dialog_bot.collective.service;

abstract class CollectiveRepository {
  Future<List<BotUser>> all();
}
