part of dialog_bot.user.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Invite {
  final String code;

  @asDateTime
  final DateTime until;

  bool get isValid => !DateTime.now().isAfter(until);

  const Invite({
    required this.code,
    required this.until,
  });

  //<editor-fold desc="Data class methods">

  Invite copyWith({
    String? code,
    DateTime? until,
  }) =>
      Invite(
        code: code ?? this.code,
        until: until ?? this.until,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invite &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          until == other.until;

  @override
  int get hashCode => code.hashCode ^ until.hashCode;

  //</editor-fold>

  //<editor-fold desc="Serialization">

  factory Invite.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$InviteFromJson(json);

  Map<String, dynamic> toJson() => _$InviteToJson(this);

//</editor-fold>
}
