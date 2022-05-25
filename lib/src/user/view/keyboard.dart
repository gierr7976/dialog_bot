part of dialog_bot.user.view;

mixin Keyboard on FlowPoint {
  ReplyMarkup getKeyboard(DialogUser? user) {
    final List<InputPoint> allButtonsPoints = build()
            ?.where(
              (element) =>
                  element is InputPoint && element.trigger is ButtonInput,
            )
            .map((point) => point as InputPoint)
            .toList() ??
        [];
    final List<ButtonInput> allButtons = allButtonsPoints
        .map(
          (point) => point.trigger as ButtonInput,
        )
        .toList();

    if (allButtons.isNotEmpty) {
      final List<ButtonInput> enabled = allButtons
          .where(
            (element) => _filterButton(user, element),
          )
          .toList();

      if (enabled.isNotEmpty) return _buildKeyboard(enabled);
    }

    return ReplyKeyboardRemove(
      remove_keyboard: true,
      selective: false,
    );
  }

  bool _filterButton(DialogUser? user, ButtonInput input) =>
      input is PermittedButtonInput ? input.isEnabled(user) : true;

  ReplyMarkup _buildKeyboard(List<ButtonInput> buttons) {
    final List<List<KeyboardButton>> keyboard = [];

    for (int i = 0; i < buttons.length; i++) {
      if (i % 2 == 0)
        keyboard.add(
          [
            buttons[i].toMarkup(),
          ],
        );
      else
        keyboard.last.add(
          buttons[i].toMarkup(),
        );
    }

    return ReplyKeyboardMarkup(
      keyboard: keyboard,
      resize_keyboard: true,
      one_time_keyboard: true,
    );
  }
}
