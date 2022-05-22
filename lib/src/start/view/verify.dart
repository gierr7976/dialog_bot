part of dialog_bot.start.view;

class VerifyPoint extends FlowPoint {
  static const String kName = 'verify';

  @override
  String get name => kName;

  FlowPoint get onSigned => SignedPoint();

  FlowPoint get onFailed => FailedPoint();

  @override
  FutureOr<void> pass() async {
    final DeeplinkScope? scope = navigator.ready.prefer();

    if (scope is DeeplinkScope && scope.group == name) {
      final String code = scope.data;

      final Inviter inviter = Inviter();
      await inviter.init();

      final bool signedUp = await inviter.accept(message.from!.id, code);

      if (signedUp) return await navigator.next(onSigned);
    }

    await navigator.next(onFailed);
  }
}

class SignedPoint extends FlowPoint {
  @override
  String get name => 'auth/verify/signed';

  @override
  FutureOr<void> pass() => navigator.next(
        Sentinel(
          onAuthenticated: () => WelcomePoint(
            next: () => AuthenticatedPoint(),
          ),
          onUnauthenticated: () => EndPoint(),
        ),
      );
}

class FailedPoint extends FlowPoint {
  static const String _reply = 'Нет, этот код не подойдёт';

  @override
  String get name => 'auth/verify/failed';

  @override
  FutureOr<void> pass() async {
    await message.reply(_reply);

    navigator.finish();
  }
}
