import 'package:dialog_bot/src/core/view/lib.dart';
import 'package:dialog_bot/src/dependencies.dart';
import 'package:dialog_bot/src/gen/config.dart';
import 'package:dialog_bot/src/home/view/lib.dart';
import 'package:dialog_bot/src/start/view/lib.dart';
import 'package:dialog_bot/src/user/view/lib.dart';

void main() async {
  Dependencies.config();

  final FlowBot bot = FlowBot(
    token: BotConfig.token,
    roots: [
      StartCommand(
        public: [
          SignupPoint.deeplink,
        ],
      ),
      HomePoint(),
    ],
  );

  await bot.start();
}
