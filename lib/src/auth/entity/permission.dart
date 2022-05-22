part of dialog_bot.auth.entity;

enum Permission {
  all,
  invite,
}

extension PermissionOperators on Permission {
  bool operator ~/(Permission other) => this == other || this == Permission.all;
}
