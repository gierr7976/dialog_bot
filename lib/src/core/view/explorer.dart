part of dialog_bot.core.view;

class _FlowExplorer {
  final List<FlowPoint> explorable;

  _FlowExplorer(this.explorable);

  FlowPoint? find(Uri route) {
    final List<String> segments = route.pathSegments;

    return _find(segments, explorable);
  }

  FlowPoint? _find(List<String> segments, List<FlowPoint> explorable) {
    final String current = segments.first;
    final FlowPoint? byCurrent = _findInline(current, explorable);

    if (segments.length == 1) return byCurrent;

    final List<FlowPoint>? belowCurrent = byCurrent?.build();

    if (belowCurrent is List<FlowPoint>)
      return _find(segments.sublist(1), belowCurrent);

    return null;
  }

  FlowPoint? _findInline(String name, List<FlowPoint> explorable) {
    for (FlowPoint point in explorable) if (point.name == name) return point;

    return null;
  }
}
