part of dialog_bot.core.view;

class Navigator extends Cubit<NavigatorState?> {
  Navigator() : super(null);

  NavigatorState get ready => state!;

  Future<void> start({
    required TeleDart tg,
    required TeleDartMessage message,
    required FlowPoint point,
  }) async {
    emit(
      NavigatorState(
        message: message,
        tg: tg,
        current: point,
      ),
    );

    _logStart(message, point);

    await _handleTo(point);
  }

  Future<void> _handleTo(FlowPoint point) async {
    point._navigator = this;
    await point.pass();
  }

  Future<void> next(FlowPoint point) async {
    emit(
      ready.copyWith(
        current: point,
      ),
    );

    _logTransition(ready.message, point);

    await _handleTo(point);
  }

  void finish() async {
    _logFinish(ready.message, ready.current);

    emit(null);
  }

  void store<T>(T data) {
    final List<dynamic> dubFree =
        ready._data.where((element) => element is! T).toList();
    dubFree.add(data);

    emit(
      ready.copyWith(data: dubFree),
    );
  }
}

class NavigatorState {
  final TeleDartMessage message;
  final TeleDart tg;
  final FlowPoint current;
  final List<dynamic> _data;

  T? prefer<T>() => _data.firstWhere(
        (element) => element is T,
        orElse: () => null,
      );

  T require<T>() => prefer()!;

  const NavigatorState({
    required this.message,
    required this.tg,
    required this.current,
    List<dynamic> data = const [],
  }) : _data = data;

  NavigatorState copyWith({
    TeleDartMessage? message,
    TeleDart? tg,
    FlowPoint? current,
    List<dynamic>? data,
  }) =>
      NavigatorState(
        message: message ?? this.message,
        tg: tg ?? this.tg,
        current: current ?? this.current,
        data: data ?? _data,
      );
}

extension _LoggedNavigator on Navigator {
  String _user(TeleDartMessage message) =>
      '[ ${message.from?.id} | @${message.from?.username}]';

  void _logStart(TeleDartMessage message, FlowPoint point) {
    final String user = _user(message);
    final String command = message.text ?? '<...>';

    slLogger.v('$user: $command');
    slLogger.v('$user started on /${point.name}');
  }

  void _logTransition(TeleDartMessage message, FlowPoint point) {
    final String user = _user(message);

    slLogger.v('$user moved to /${point.name}');
  }

  void _logFinish(TeleDartMessage message, FlowPoint current) {
    final String user = _user(message);

    slLogger.v('$user finished on /${current.name}');
  }
}
