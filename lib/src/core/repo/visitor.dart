part of dialog_bot.core.repo;

abstract class VisitorRepository {
  Future<Visitor?> fetch(int id);

  Future<void> store(Visitor visitor);
}

class MongoVisitorRepository extends MongoRepository
    implements VisitorRepository {
  String get collection => 'visitors';

  MongoVisitorRepository(super.service);

  @override
  Future<Visitor?> fetch(int id) async {
    final Map<String, dynamic>? raw = await db.collection(collection).findOne(
      {'id': id},
    );

    if (raw is Map<String, dynamic>) return parseRaw(raw);

    return null;
  }

  @protected
  Visitor parseRaw(Map<String, dynamic> raw) => Visitor.fromJson(raw);

  @override
  Future<void> store(Visitor visitor) async {
    final Map<String, dynamic> raw = visitor.toJson();

    final WriteResult updateResult = await db.collection(collection).replaceOne(
      {'_id': visitor.key},
      raw,
    );

    if (updateResult.nMatched < 1)
      await db.collection(collection).insertOne(
            visitor.toJson(),
          );
  }
}
