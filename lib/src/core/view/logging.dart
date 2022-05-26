part of dialog_bot.core.view;

extension LoggableUser on User {
  String get debugName => '[ id: $id | @$username ]';
}
