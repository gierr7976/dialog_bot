part of dialog_bot.navigation.entity;

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Visitor extends Entity {
  final int id;

  final String route;

  Visitor({
    required ObjectId key,
    required this.id,
    this.route = BotConfig.home_route,
  }) : super(key: key);

  //<editor-fold desc="Data class methods">

  @override
  Visitor copyWith({
    int? id,
    ObjectId? key,
    String? route,
  }) =>
      Visitor(
        id: id ?? this.id,
        key: key ?? this.key,
        route: route ?? this.route,
      );

  //</editor-fold>

  //<editor-fold desc="Serialization">

  factory Visitor.fromJson(Map<String, dynamic> json) =>
      _$VisitorFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorToJson(this);

//</editor-fold>
}
