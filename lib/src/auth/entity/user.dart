part of dialog_bot.auth.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BotUser extends Visitor {
  static const int unregisteredId = -42;

  final List<Permission> permissions;

  final String fullName;

  final Invite? invite;

  bool get isRegistered => id != unregisteredId;

  BotUser({
    required ObjectId key,
    int id = BotUser.unregisteredId,
    required this.fullName,
    this.invite,
    this.permissions = const [],
    String route = BotConfig.home_route,
  }) : super(
          key: key,
          id: id,
          route: route,
        ) {
    assert(
      _assertState(),
      'BotUser can not be in both unregistered & registered state',
    );
  }

  factory BotUser.create(String fullName) {
    final int hash = fullName.hashCode ^ Random.secure().nextInt(100000);
    final String code = hash.toRadixString(16).substring(0, 8);

    return BotUser(
      key: ObjectId(),
      fullName: fullName,
      invite: Invite(
        code: code,
        until: DateTime.now().add(BotConfig.signup_code_lifetime),
      ),
    );
  }

  bool _assertState() => (invite is Invite) ^ (id != unregisteredId);

  bool isAllowed(Permission permission) => permissions.any(
        (granted) => granted ~/ permission,
      );

  //<editor-fold desc="Data class methods">

  BotUser dropInvite(int id) => BotUser(
        key: key,
        id: id,
        fullName: fullName,
        route: route,
        permissions: permissions,
      );

  @override
  BotUser copyWith({
    String? fullName,
    ObjectId? key,
    int? id,
    List<Permission>? permissions,
    Invite? signupCode,
    String? route,
  }) =>
      BotUser(
        fullName: fullName ?? this.fullName,
        key: key ?? this.key,
        id: id ?? this.id,
        permissions: permissions ?? this.permissions,
        invite: signupCode ?? invite,
        route: route ?? this.route,
      );

  //</editor-fold>

  //<editor-fold desc="Serialization">

  @override
  Map<String, dynamic> toJson() => _$BotUserToJson(this);

  factory BotUser.fromJson(Map<String, dynamic> json) =>
      _$BotUserFromJson(json);

//</editor-fold>
}
