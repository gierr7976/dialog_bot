part of dialog_bot.core.view;

abstract class FlowPoint {
  List<Input> get triggers => [];

  String get name;

  bool get shouldStore => false;

  const FlowPoint();

  List<FlowPoint>? build() => null;

  FutureOr<String?> handle(FlowNavigator navigator) => null;
}
