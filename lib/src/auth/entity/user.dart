part of dialog_bot.auth.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class BotUser extends Visitor {
  static const int unregisteredId = -42;

  final int? chatId;

  final String fullName;

  final SignupCode? signupCode;

  bool get isRegistered => id != unregisteredId;

  BotUser({
    required ObjectId key,
    int id = BotUser.unregisteredId,
    required this.fullName,
    this.chatId,
    this.signupCode,
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

  bool _assertState() =>
      (signupCode is SignupCode) ^ (id == unregisteredId || chatId is int);

  //<editor-fold desc="Data class methods">

  @override
  BotUser copyWith({
    int? chatId,
    String? fullName,
    ObjectId? key,
    int? id,
    String? route,
  }) =>
      BotUser(
        chatId: chatId ?? this.chatId,
        fullName: fullName ?? this.fullName,
        key: key ?? this.key,
        id: id ?? this.id,
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
