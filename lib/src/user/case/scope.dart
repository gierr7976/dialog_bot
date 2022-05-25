part of dialog_bot.user.usecase;

class UserScope extends Cubit<DialogUser?> {
  DialogUser get logged => state!;

  late final UserRepository _repository;

  UserScope() : super(null);

  Future<void> init() async => _repository = await GetIt.instance.getAsync();

  Future<void> signup(int id, String code) async {
    final DialogUser? user = await _repository.fetchByCode(code);

    if (user is DialogUser)
      emit(
        user.acceptInvite(id, code),
      );
  }

  void update(DialogUser user) {
    final bool isProtectedModified = user != state;

    if (!isProtectedModified) emit(user);
  }
}
