part of dialog_bot.home.view;

abstract class MenuPoint extends FlowPoint with Stored {
  String get button;

  @override
  FutureOr<void> pass() async {
    final UserScope scope = navigator.ready.require();
    final BotUser user = scope.ready;

    if (scope.authenticated) return forUser(user);

    navigator.finish();
  }

  FutureOr<void> forUser(BotUser user);

  ReplyMarkup keyboard(BotUser user);
}
