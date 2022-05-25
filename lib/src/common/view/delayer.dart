part of dialog_bot.common.view;

typedef DelayedFunction = Future<void> Function();

class Delayer {
  static const Duration fallbackDelay = Duration(milliseconds: 1200);

  final Duration delay;

  final List<DelayedFunction> delayed;

  const Delayer({
    required this.delayed,
    this.delay = Delayer.fallbackDelay,
  });

  Future<void> run() async {
    for (DelayedFunction delayed in this.delayed) {
      await delayed();
      await Future.delayed(delay);
    }
  }
}
