part of dialog_bot.user.view;

extension AuthenticatedNavigator on FlowNavigator {
  DialogUser? get user =>
      state?.visitor is DialogUser ? state!.visitor as DialogUser : null;
}
