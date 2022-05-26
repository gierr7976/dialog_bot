part of dialog_bot.start.view;

class DeeplinkForwarder {
  final String group;
  final String dataPattern;
  final String next;

  const DeeplinkForwarder({
    required this.group,
    required this.dataPattern,
    required this.next,
  });

  bool matching(String text) =>
      RegExp('^\\/start $group-$dataPattern\$').firstMatch(text)?[0] == text;
}
