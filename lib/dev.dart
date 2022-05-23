import 'package:dialog_bot/src/dependencies.dart';

void main() async {
  Dependencies.config();
/*
  final FlowBot bot = FlowBot(
    token: BotConfig.token,
    listeners: [
      StartListener(),
      LetsGoListener(),
      HomeListener(),
    ],
    publicCommands: [
      BotCommand(
        command: StartListener.command,
        description: 'Запустить бота',
      ),
      BotCommand(
        command: HomeListener.command,
        description: 'Домашняя страница',
      ),
    ],
  );

  await bot.start();*/
}
