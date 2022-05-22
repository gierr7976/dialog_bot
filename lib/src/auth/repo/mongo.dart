part of dialog_bot.auth.repo;

@Injectable(as: UserRepository)
class MongoUserRepository extends MongoRepository implements UserRepository {
  static const collection = 'bot_users';

  MongoUserRepository(MongoService service) : super(service);

  @override
  bool get allowUnauthorizedRouting => false;

  @override
  Future<Visitor?> fetch(int id) async {
    final Map<String, dynamic>? json = await db.collection(collection).findOne(
      {'id': id},
    );

    if (json is Map<String, dynamic>)
      try {
        return BotUser.fromJson(json);
      } catch (_) {
        return Visitor.fromJson(json);
      }

    return null;
  }

  @override
  Future<BotUser?> fetchUser(int id) async {
    final Visitor? visitor = await fetch(id);

    if (visitor is BotUser) return visitor;

    return null;
  }

  @override
  Future<void> create(Visitor visitor) async {
    final bool canCreate = allowUnauthorizedRouting ? true : visitor is BotUser;

    if (canCreate) {
      await db.collection(collection).insert(
            visitor.toJson(),
          );
    }
  }

  @override
  Future<void> updateRoute(Visitor visitor) async {
    final bool canUpdate = allowUnauthorizedRouting ? true : visitor is BotUser;

    if (canUpdate) {
      await db.collection(collection).update(
        {'_id': visitor.key},
        modify.set(
          'route',
          visitor.route,
        ),
      );
    }
  }

  @override
  Future<BotUser?> fetchByCode(String code) async {
    final Map<String, dynamic>? json = await db.collection(collection).findOne(
          where.eq('invite.code', code),
        );

    if (json is Map<String, dynamic>) return BotUser.fromJson(json);

    return null;
  }

  @override
  Future<void> update(BotUser user) async {
    await db.collection(collection).replaceOne(
      {'_id': user.key},
      user.toJson(),
    );
  }
}

@Injectable(as: VisitorRepository)
class MongoVisitorRepository extends MongoUserRepository {
  MongoVisitorRepository(MongoService service) : super(service);
}
