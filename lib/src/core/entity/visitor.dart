part of dialog_bot.core.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Visitor extends Entity {
  final int? id;
  final Uri route;

  const Visitor({
    required super.key,
    required this.route,
    this.id,
  });

  factory Visitor.create({required int id}) => Visitor(
        key: ObjectId(clientMode: true),
        id: id,
        route: Uri.parse(BotConfig.home_route),
      );

  //<editor-fold desc="Data class methods">

  @override
  Visitor copyWith({
    int? id,
    Uri? route,
    ObjectId? key,
  }) =>
      Visitor(
        key: key ?? this.key,
        id: id ?? this.id,
        route: route ?? this.route,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is Visitor &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => super.hashCode ^ id.hashCode;

  //</editor-fold>

  //<editor-fold desc="Serialization">

  factory Visitor.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$VisitorFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorToJson(this);

//</editor-fold>
}
