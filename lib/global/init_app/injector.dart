import 'package:app/domain/env_config/env_url.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:app/global/init_app/initialize_dependencies.dart';
import 'package:app/global/init_app/injector_rest_client.dart';
import 'initialize_core.dart';
import 'injector.config.dart';

final sl = GetIt.instance;

enum Envirement { dev, uat, prod }

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => sl.init();

Future init({Envirement? initEnv}) async {
  configureDependencies();
  if (initEnv != null) {
    sl.reset(dispose: false);
  }
  await injectCore();
  await injectRestClient();
  await env(env: initEnv);
  await initializeDependencies();

  /// Home
}

Future env({Envirement? env}) async {
  // if (env != null) {
    sl.registerLazySingleton<EnvUrl>(() => EnvUrl(Envirement.prod));
  // } 
  //   final flavor =
  //       await const MethodChannel('flavor').invokeMethod<String>('getFlavor');
  //   if (flavor == 'prod') {
  //     sl.registerLazySingleton<EnvUrl>(() => EnvUrl(Envirement.prod));
  //   } else if (flavor == 'uat') {
  //     sl.registerLazySingleton<EnvUrl>(() => EnvUrl(Envirement.uat));
  //   } else {
  //     sl.registerLazySingleton<EnvUrl>(() => EnvUrl(Envirement.dev));
  //   }
  // }
}
