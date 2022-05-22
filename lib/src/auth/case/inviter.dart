part of dialog_bot.auth.usecase;

class Inviter {
  late final UserRepository _repository;

  Future<void> init() async {
    _repository = await GetIt.instance.getAsync();
  }

  Future<bool> invite(UserScope scope, String fullName) async {
    if (scope.ready.isAllowed(Permission.invite)) {
      final BotUser user = BotUser.create(fullName);

      await _repository.create(user);
      return true;
    }

    return false;
  }

  Future<bool> accept(int id, String code) async {
    final BotUser? user = await _repository.fetchByCode(code);

    if (user is BotUser) {
      final SignupCode? signupCode = user.signupCode;

      if (signupCode is SignupCode && signupCode.isValid) {
        final BotUser signedUp = user.dropSignupCode(id);

        await _repository.update(signedUp);
        return true;
      }
    }

    return false;
  }
}
