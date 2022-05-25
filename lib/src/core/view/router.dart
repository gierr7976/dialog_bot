part of dialog_bot.core.view;

@visibleForTesting
class PointRouter {
  final RootPoint root;

  //<editor-fold desc="Input getters">

  List<InputScope> get inputScopes {
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

  Map<Uri, InputPoint> get _inputMap => Map.fromEntries(
        _pointMap.entries.where(
          (entry) => entry.value is InputPoint,
        ) as List<MapEntry<Uri, InputPoint>>,
      );

  List<InputPoint> get globalInputs => _inputMap.entries
      .where(
        (entry) =>
            entry.key ==
            Uri.parse(
              entry.value.applyRoute(''),
            ),
      )
      .map((entry) => entry.value)
      .toList();

  //</editor-fold>

  late final Map<Uri, FlowPoint> _pointMap;

  PointRouter(this.root) {
    _pointMap = _extractRoot(root);
  }

  FlowPoint byRoute({String? raw, Uri? global, Uri? base}) {
    final Uri route = routeFrom(raw: raw, global: global, base: base);

    final FlowPoint? result = _pointMap[route];

    if (result is FlowPoint) return result;

    throw ArgumentError('Unknown route');
  }

  //<editor-fold desc="Route builders">

  Uri routeFrom({String? raw, Uri? global, Uri? base}) {
    if (global is Uri)
      return global;
    else if (raw is String)
      return _routeFromRaw(raw, base);
    else
      throw ArgumentError('Raw or global should be presented');
  }

  Uri _routeFromRaw(String raw, Uri? base) {
    if (raw[0] == '/')
      return Uri.parse(raw);
    else {
      if (base is Uri)
        return Uri.parse('$base/$raw');
      else
        throw ArgumentError('Base shall be presented with local route');
    }
  }

  //</editor-fold>

  //<editor-fold desc="Extractors">

  Map<Uri, FlowPoint> _extractRoot(RootPoint point) => {
        for (FlowPoint sub in point.children) ..._extractNonRoot('', sub),
      };

  Map<Uri, FlowPoint> _extractNonRoot(String route, FlowPoint point) {
    final String applied = point.applyRoute(route);

    return {
      Uri.parse(applied): point,
      for (FlowPoint sub in point.children) ..._extractNonRoot(applied, sub),
    };
  }

//</editor-fold>
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
    final Uri match = Uri.parse('$base/${input.key}');

    for (Uri variant in variants) if (variant == match) return variant;

    return null;
  }

  Stream<TeleDartMessage> build(TeleDart tg) => input.build(tg);
}
