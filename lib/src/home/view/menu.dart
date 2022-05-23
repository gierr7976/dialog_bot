part of dialog_bot.home.view;

abstract class MenuPoint extends FlowPoint with Stored {
  KeyboardButton get button;

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

class MenuKeyboard {
  final List<MenuPoint> targets;

  const MenuKeyboard({
    required this.targets,
  });

  ReplyMarkup get markup => targets.isNotEmpty
      ? _buildMarkup()
      : ReplyKeyboardRemove(
          remove_keyboard: true,
          selective: false,
        );

  ReplyKeyboardMarkup _buildMarkup() {
    final List<List<KeyboardButton>> keyboard = [];

    for (int i = 0; i < targets.length; i++) {
      final MenuPoint point = targets[i];

      if (i % 2 == 0)
        keyboard.add(
          [point.button],
        );
      else
        keyboard.last.add(point.button);
    }

    return ReplyKeyboardMarkup(
      keyboard: keyboard,
      one_time_keyboard: true,
      resize_keyboard: true,
    );
  }
}
