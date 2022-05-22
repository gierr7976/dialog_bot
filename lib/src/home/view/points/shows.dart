part of dialog_bot.home.view;

class ShowsPoint extends FlowPoint {
  static const String kName = 'home/shows';
  static const String kButton = '\u{1F4D6} Постановки';

  @override
  String get name => kName;

  @override
  FutureOr<void> pass() => navigator.next(
        TodoPoint(
          next: () => HomePoint(),
        ),
      );
}
