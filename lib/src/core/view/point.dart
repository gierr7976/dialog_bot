part of dialog_bot.core.view;

abstract class FlowPoint {
  List<Input> get triggers => [];

  String get name;

  bool get shouldStore => false;

  const FlowPoint();

  FutureOr<FlowPoint?> handle(FlowNavigator navigator);
}

abstract class RootPoint extends FlowPoint {
  final FlowPoint from;

  const RootPoint(this.from);

  @override
  FutureOr<FlowPoint?> handle(FlowNavigator navigator) => from;
}
