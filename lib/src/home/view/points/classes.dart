part of dialog_bot.home.view;

class ClassesPoint extends FlowPoint {
  static const String kName = 'home/classes';
  static const String kButton = '\u{1F4CD} Репетиции';

  @override
  String get name => kName;

  @override
  FutureOr<void> pass() => navigator.next(
        TodoPoint(
          next: () => HomePoint(),
        ),
      );
}
