part of dialog_bot.user.view;

class SignupPoint extends FlowPoint {
  static const String group = 'signup';
  static final String dataPattern = r'\w{8,}';

  static DeeplinkForwarder get deeplink => DeeplinkForwarder(
        group: group,
        dataPattern: dataPattern,
        next: '/start/signup',
      );

  @override
  final String name = group;

  @override
  FutureOr<String?> handle(FlowNavigator navigator) async {
    final Inviter inviter = Inviter();
    await inviter.init();

    final String code =
        RegExp(dataPattern).firstMatch(navigator.message.text ?? '')?[0] ?? '';

    final DialogUser? signed = (await inviter.signup(
      navigator.message.from!.id,
      code,
    ))
        ?.copyWith(
      route: navigator.ready.visitor.route,
    );

    if (signed is DialogUser) {
      navigator.updateVisitor(signed);
      return '/start/authenticated';
    }

    return null;
  }
}
