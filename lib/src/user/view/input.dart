part of dialog_bot.user.view;

abstract class SecureInputPoint extends InputPoint {
  const SecureInputPoint();

  @override
  FutureOr<String?> handle(FlowNavigator navigator) {
    final DialogUser? user = navigator.user;

    if (user is DialogUser) return onAuthorized(navigator);

    return onNonAuthorized(navigator);
  }

  FutureOr<String?> onAuthorized(FlowNavigator navigator);

  FutureOr<String?> onNonAuthorized(FlowNavigator navigator) => null;
}

class PermittedButtonInput extends ButtonInput {
  final bool authorized;

  final Permission? permission;

  PermittedButtonInput({
    required super.name,
    required super.text,
    this.authorized = true,
    this.permission,
  });

  bool isEnabled(DialogUser? user) => authorized
      ? user is DialogUser
          ? user.isAllowed(permission)
          : false
      : true;
}
