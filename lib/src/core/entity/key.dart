part of dialog_bot.core.entity;

abstract class Entity {
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
