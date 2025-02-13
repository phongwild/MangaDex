import 'package:app/core/networking/rest_client.dart';
import 'package:app/domain/env_config/env_url.dart';
import 'package:app/domain/env_config/env_url_type.dart';
import 'package:app/global/router/app_router.dart';

Future<void> injectRestClient() async {
  /// Flex
  sl.registerLazySingleton(() => getRestClient(sl<EnvUrl>().flexUrl()),
      instanceName: EnvUrlEnum.flex.name);

  /// Base
  sl.registerLazySingleton(() => getRestClient(sl<EnvUrl>().baseUrl()),
      instanceName: EnvUrlEnum.base.name);

  /// Socket
  sl.registerLazySingleton(() => getRestClient(sl<EnvUrl>().socketUrl()),
      instanceName: EnvUrlEnum.socket.name);

  /// Bond
  sl.registerLazySingleton(() => getRestClient(sl<EnvUrl>().bondUrl()),
      instanceName: EnvUrlEnum.bond.name);

  /// NoAuth
  sl.registerLazySingleton(
      () => getRestClient(sl<EnvUrl>().noAuthUrl(),
          authenticator: false, handleUnauthorizedError: false),
      instanceName: EnvUrlEnum.noAuth.name);
}
