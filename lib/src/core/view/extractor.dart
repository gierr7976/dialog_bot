part of dialog_bot.core.view;

class _InputExtractor {
  final RootPoint root;

  late final Map<Uri, InputPoint> _inputMap;

  Map<Uri, InputPoint> get inputMap => _inputMap;

  _InputExtractor(this.root) {
    _inputMap = _extractOne('', root);
  }

  List<InputScope> on(TeleDart tg) {
    final List<Input> unique = [];

    for (InputPoint point in _inputMap.values)
      if (!unique.contains(point.trigger)) unique.add(point.trigger);

    return unique
        .map(
          (input) => InputScope(
            input: input,
            variants: _inputMap.entries
                .where((entry) => entry.value.trigger.key == input.key)
                .map((entry) => entry.key)
                .toList(),
          ),
        )
        .toList();
  }

  Map<Uri, InputPoint> _extractOne(String route, FlowPoint point) => {
        if (point is InputPoint)
          Uri.parse(
            _apply(route, point),
          ): point,
        for (FlowPoint sub in point.build() ?? [])
          ..._extractOne(_apply(route, point), sub)
      };

  String _apply(String route, FlowPoint point) => '$route/${point.name}';
}

class InputScope {
  final Input input;
  final List<Uri> variants;

  Uri? get global => match(
        Uri.parse(''),
      );

  const InputScope({
    required this.input,
    required this.variants,
  });

  Uri? match(Uri base) {
    final String baseString = base.toString();
    final Uri match = Uri.parse('$baseString/${input.key}');

    for (Uri variant in variants) if (variant == match) return variant;

    return null;
  }

  Stream<TeleDartMessage> build(TeleDart tg) => input.build(tg);
}
