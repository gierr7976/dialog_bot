part of dialog_bot.auth.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Invite {
  final String code;

  @asDateTime
  final DateTime until;

  bool get isValid => DateTime.now().isBefore(until);

  const Invite({
    required this.code,
    required this.until,
  });

  factory Invite.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$InviteFromJson(json);

  Map<String, dynamic> toJson() => _$InviteToJson(this);

  Invite copyWith({
    String? code,
    DateTime? until,
  }) =>
      Invite(
        code: code ?? this.code,
        until: until ?? this.until,
      );
}
