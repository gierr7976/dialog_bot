part of dialog_bot.auth.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SignupCode {
  final String code;

  @asDateTime
  final DateTime until;

  bool get isValid => DateTime.now().isBefore(until);

  const SignupCode({
    required this.code,
    required this.until,
  });

  factory SignupCode.fromJson(Map<String, dynamic> json) =>
      _$SignupCodeFromJson(json);

  Map<String, dynamic> toJson() => _$SignupCodeToJson(this);

  SignupCode copyWith({
    String? code,
    DateTime? until,
  }) =>
      SignupCode(
        code: code ?? this.code,
        until: until ?? this.until,
      );
}
