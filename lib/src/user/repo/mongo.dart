part of dialog_bot.user.repo;

@Injectable(as: UserRepository)
class MongoUserRepository extends MongoVisitorRepository
    implements UserRepository {
  @override
  String get collection => 'dialog_users';

  MongoUserRepository(super.service);

  @override
  Future<DialogUser?> fetch(int id) => super.fetch(id) as Future<DialogUser?>;

  @override
  Future<DialogUser?> fetchByCode(String code) async {
    final Map<String, dynamic>? raw = await db.collection(collection).findOne(
          where.eq('invite.code', code),
        );

    if (raw is Map<String, dynamic>) return parseRaw(raw);

    return null;
  }

  @override
  DialogUser parseRaw(Map<String, dynamic> raw) => DialogUser.fromJson(raw);
}

//<editor-fold desc="DI">

@Injectable(as: VisitorRepository)
class MongoUserVisitorRepository extends MongoUserRepository {
  MongoUserVisitorRepository(super.service);
}

//</editor-fold>
