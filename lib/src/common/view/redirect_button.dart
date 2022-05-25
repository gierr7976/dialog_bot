part of dialog_bot.common.view;

class RedirectButton extends SecureInputPoint {
  @override
  final String name;

  final String text;

  @override
  ButtonInput get trigger => ButtonInput(name: name, text: text);

  final String? next;

  @override
  final List<FlowPoint> children;

  const RedirectButton({
    required this.name,
    required this.text,
    this.next,
    this.children = const [],
  });

  @override
  FutureOr<String?> onAuthorized(FlowNavigator navigator) => next;
}
