part of dialog_bot.core.repo;

@singleton
class MongoService {
  @factoryMethod
  static Future<MongoService> create() async {
    final String uri = BotConfig.mongo_uri;

    _logStarting(uri);

    final Db db = Db(uri);
    await db.open();

    _logStarted();

    return MongoService(db);
  }

  final Db db;

  MongoService(this.db);

  Future<void> dispose() async {
    await db.close();

    _logDisposed();
  }

  //<editor-fold desc="Debug methods">

  static void _logStarting(String uri) =>
      slLogger.i('[REPO] Starting MongoDB service on $uri');

  static void _logStarted() => slLogger.i('[REPO] MongoDB service started');

  static void _logDisposed() => slLogger.w('[REPO] MongoDB service disposed');

//</editor-fold>

}
