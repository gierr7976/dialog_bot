part of dialog_bot.user.usecase;

class Inviter {
  late final UserRepository _repository;

  Future<void> init() async => _repository = await GetIt.instance.getAsync();

  Future<Invite> invite(String fullName) async {
    final String code = _generateCode();

    final Invite invite = Invite(
      code: code,
      until: DateTime.now().add(BotConfig.invite_lifetime),
    );

    final DialogUser user = DialogUser.create(
      fullName: fullName,
      invite: invite,
    );

    await _repository.store(user);

    return invite;
  }

  String _generateCode() {
    final Random random = Random.secure();

    final List<int> bytes = [
      for (int i = 0; i < 8; i++) random.nextInt(1 << 32),
    ];

    final int numCode = sha256.convert(bytes).bytes.reduce(
          (value, element) => value ^ element,
        );

    return numCode.toRadixString(16).substring(0, 8);
  }

  Future<bool> signup(int id, String code) async {
    final DialogUser? invited = await _repository.fetchByCode(code);

    if (invited is DialogUser) {
      final DialogUser? signedUp = invited.acceptInvite(id, code);

      if (signedUp is DialogUser) {
        await _repository.store(signedUp);
        return true;
      }

      await _repository.deleteByCode(code);
    }

    return false;
  }
}
