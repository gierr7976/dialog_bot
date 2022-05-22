part of dialog_bot.auth.view;

abstract class AuthenticatedListener extends MessageListener {
  FlowPoint get onAuthenticated;

  FlowPoint get onUnauthenticated;

  @override
  FlowPoint get from => Sentinel(
        onAuthenticated: onAuthenticated,
        onUnauthenticated: onUnauthenticated,
      );
}
