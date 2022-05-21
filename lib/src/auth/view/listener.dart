part of dialog_bot.auth.view;

abstract class AuthenticatedListener extends MessageListener {
  FlowPoint onAuthenticated();

  FlowPoint onUnauthenticated();

  @override
  FlowPoint get from => Sentinel(
        onAuthenticated: onAuthenticated,
        onUnauthenticated: onUnauthenticated,
      );
}
