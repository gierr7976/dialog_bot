part of dialog_bot.core.view;

abstract class Input {
  final Object key;

  const Input({
    required this.key,
  });

  Stream<TeleDartMessage> build(TeleDart tg);

  bool matches(TeleDartMessage message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Input && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}

class CommandInput extends Input {
  final String command;
  final String description;

  BotCommand get botCommand => BotCommand(
        command: command,
        description: description,
      );

  const CommandInput({
    required this.command,
    required this.description,
  }) : super(
          key: command,
        );

  @override
  Stream<TeleDartMessage> build(TeleDart tg) => tg.onCommand(command);

  @override
  bool matches(TeleDartMessage message) =>
      message.text?.contains(
        RegExp('\\/$command'),
      ) ??
      false;
}

class TextInput extends Input {
  final String name;
  final Pattern pattern;

  const TextInput({
    required this.name,
    required this.pattern,
  }) : super(key: name);

  @override
  Stream<TeleDartMessage> build(TeleDart tg) => tg.onMessage(keyword: pattern);

  @override
  bool matches(TeleDartMessage message) =>
      pattern.allMatches(message.text ?? '').first[0] == pattern;
}

class ButtonInput extends TextInput {
  String get text => pattern.toString();

  ButtonInput({
    required super.name,
    required String text,
  }) : super(
          pattern: text,
        );

  KeyboardButton toMarkup() => KeyboardButton(
        text: text,
      );
}
