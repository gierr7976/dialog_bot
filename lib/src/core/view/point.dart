part of dialog_bot.core.view;

abstract class FlowPoint implements Named {
  Navigator? _navigator;

  @protected
  Navigator get navigator => _navigator!;

  @protected
  TeleDart get tg => navigator.ready.tg;

  @protected
  TeleDartMessage get message => navigator.ready.message;

  FutureOr<void> pass();
}
