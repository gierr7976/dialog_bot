part of dialog_bot.start.view;

class DeeplinkPoint extends FlowPoint {
  final FlowPoint plain;
  final Map<String, FlowPoint> map;

  @override
  String get name => 'deeplink';

  DeeplinkPoint({
    required this.map,
    required this.plain,
  });

  @override
  FutureOr<void> pass() {
    final RegExp regExp = RegExp(r'\w+-\w+');
    final String input = message.text ?? '';
    final RegExpMatch? match = regExp.firstMatch(input);

    if (match is RegExpMatch) {
      final List<String> payload = match[0]!.split('-');
      final String group = payload.first;
      final String data = payload.last;

      navigator.store(
        DeeplinkScope(group: group, data: data),
      );

      final FlowPoint next = map[group] ?? plain;

      return navigator.next(next);
    }

    return navigator.next(plain);
  }
}

class DeeplinkScope {
  final String group;
  final String data;

  const DeeplinkScope({
    required this.group,
    required this.data,
  });

  DeeplinkScope copyWith({
    String? group,
    String? data,
  }) =>
      DeeplinkScope(
        group: group ?? this.group,
        data: data ?? this.data,
      );
}
