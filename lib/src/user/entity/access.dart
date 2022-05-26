part of dialog_bot.user.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Position {
  final String name;
  final List<Permission> permissions;

  const Position({
    required this.name,
    required this.permissions,
  });

  bool isAllowed(Permission? permission) => permissions.any(
        (allowed) => allowed >> permission,
      );

  //<editor-fold desc="Data class methods">

  Position copyWith({
    String? name,
    List<Permission>? permissions,
  }) =>
      Position(
        name: name ?? this.name,
        permissions: permissions ?? this.permissions,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  //</editor-fold>

  //<editor-fold desc="Serialization">

  factory Position.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);

//</editor-fold>
}

@JsonEnum(fieldRename: FieldRename.snake)
enum Permission {
  all,
  invite,
}

extension PermissionComparison on Permission {
  bool operator >>(Permission? other) =>
      this == other || this == Permission.all || other == null;
}
