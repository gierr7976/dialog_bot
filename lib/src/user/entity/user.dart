part of dialog_bot.user.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DialogUser extends Visitor {
  final String fullName;

  final List<Position> positions;

  const DialogUser({
    required super.key,
    required super.id,
    required super.route,
    required this.fullName,
    required this.positions,
  });

  bool isAllowed(Permission permission) => positions.any(
        (position) => position.isAllowed(permission),
      );

  //<editor-fold desc="Data class methods">

  @override
  DialogUser copyWith({
    int? id,
    Uri? route,
    ObjectId? key,
    String? fullName,
    List<Position>? positions,
  }) =>
      DialogUser(
        id: id ?? this.id,
        route: route ?? this.route,
        key: key ?? this.key,
        fullName: fullName ?? this.fullName,
        positions: positions ?? this.positions,
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
