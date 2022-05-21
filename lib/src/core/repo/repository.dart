part of dialog_bot.core.repo;

abstract class MongoRepository {
  final MongoService service;

  Db get db => service.db;

  const MongoRepository(this.service);
}
