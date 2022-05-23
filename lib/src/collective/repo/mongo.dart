part of dialog_bot.collective.service;

@Injectable(as: CollectiveRepository)
class MongoCollectiveRepository extends MongoRepository
    implements CollectiveRepository {
  static const String collection = 'bot_users';

  MongoCollectiveRepository(MongoService service) : super(service);

  @override
  Future<List<BotUser>> all() async {
    List<Map<String, dynamic>> raw = await (db.collection(collection).find(
          where.ne('id', null),
        )).toList();

    return [
      for (Map<String, dynamic> rawUser in raw) BotUser.fromJson(rawUser),
    ];
  }
}
