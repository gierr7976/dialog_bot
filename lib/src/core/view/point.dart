part of dialog_bot.core.view;

abstract class FlowPoint {
  String get name;

  bool get shouldStore => false;

  const FlowPoint();

  List<FlowPoint>? build() => null;

  FutureOr<String?> handle(FlowNavigator navigator) => null;
}

@visibleForTesting
class RootPoint extends FlowPoint {
  static bool _assertHomeExists(List<FlowPoint> roots, String home) =>
      roots.any((point) => point.name == home);

  @override
  final String name = '/';

  final String home;

  final List<FlowPoint> roots;

  RootPoint({
    required this.roots,
    this.home = BotConfig.home_route,
  }) : assert(_assertHomeExists(roots, home));

  @override
  List<FlowPoint> build() => roots;

  @override
  FutureOr<String?> handle(FlowNavigator navigator) =>
      throw UnsupportedError('Storage only');
}

abstract class InputPoint extends FlowPoint {
  Input get trigger;

  const InputPoint();

  @override
  FutureOr<String?> handle(FlowNavigator navigator);
}
