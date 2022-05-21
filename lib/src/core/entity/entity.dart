part of dialog_bot.core.entity;

abstract class Entity {
  @asObjId
  @JsonKey(name: '_id')
  final ObjectId key;

  const Entity({
    required this.key,
  });

  @override
  @mustCallSuper
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && key == other.key;

  @override
  @mustCallSuper
  int get hashCode => key.hashCode;

  Entity copyWith({
    ObjectId? key,
  });
}

const ObjectIdConverter asObjId = ObjectIdConverter();

class ObjectIdConverter extends JsonConverter<ObjectId, ObjectId> {
  const ObjectIdConverter();

  @override
  ObjectId fromJson(ObjectId json) => json;

  @override
  ObjectId toJson(ObjectId object) => object;
}
