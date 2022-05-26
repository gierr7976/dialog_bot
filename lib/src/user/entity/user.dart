part of dialog_bot.user.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DialogUser extends Visitor {
  final String fullName;

  final List<Position> positions;

  final Invite? invite;

  const DialogUser({
    required super.key,
    super.id,
    required super.route,
    required this.fullName,
    this.positions = const [],
    this.invite,
  });

  DialogUser.create({
    required this.fullName,
    required this.invite,
    this.positions = const [],
  }) : super(
          key: ObjectId(clientMode: true),
          route: Uri.parse(BotConfig.home_route),
        );

  bool isAllowed(Permission? permission) => permission is Permission
      ? positions.any(
          (position) => position.isAllowed(permission),
        )
      : true;

  DialogUser? acceptInvite(int id, String code) {
    final bool correctAndValid =
        invite?.code == code && (invite?.isValid ?? false);

    if (correctAndValid)
      return DialogUser(
        key: key,
        id: id,
        route: route,
        fullName: fullName,
        positions: positions,
      );

    return null;
  }

  //<editor-fold desc="Data class methods">

  @override
  DialogUser copyWith({
    int? id,
    Uri? route,
    ObjectId? key,
    String? fullName,
    List<Position>? positions,
    Invite? invite,
  }) =>
      DialogUser(
        id: id ?? this.id,
        route: route ?? this.route,
        key: key ?? this.key,
        fullName: fullName ?? this.fullName,
        positions: positions ?? this.positions,
        invite: invite ?? this.invite,
      );

  //</editor-fold>

  //<editor-fold desc="Serialization">

  factory DialogUser.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DialogUserFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DialogUserToJson(this);

//</editor-fold>
}
