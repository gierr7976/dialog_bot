import 'package:dialog_bot/src/dependencies.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(preferRelativeImports: false)
void _cfgDeps(Environment environment) => $initGetIt(GetIt.instance);

abstract class Dependencies {
  void config([Environment environment = dev]) => _cfgDeps(environment);
}
