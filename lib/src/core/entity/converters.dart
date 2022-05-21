part of dialog_bot.core.entity;

const ObjectIdConverter asObjId = ObjectIdConverter();

const DateTimeConverter asDateTime = DateTimeConverter();

class BypassConverter<T> extends JsonConverter<T, T> {
  const BypassConverter();

  @override
  T fromJson(T json) => json;

  @override
  T toJson(T object) => object;
}

class ObjectIdConverter extends BypassConverter<ObjectId> {
  const ObjectIdConverter();
}

class DateTimeConverter extends BypassConverter<DateTime> {
  const DateTimeConverter();
}
