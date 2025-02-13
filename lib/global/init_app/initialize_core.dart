import 'package:app/core/cache/shared_prefs.dart';
import 'package:app/core/networking/interceptor/logger_interceptor.dart';
import 'package:app/global/router/app_router.dart';
import 'package:app/global/router/navigator.dart';

Future<void> injectCore() async {
  /// [Interceptor]
  sl.registerFactory<LoggerInterceptor>(() => LoggerInterceptor());

  /// [Share preference]
  sl.registerFactory<SharedPref>(() => SharedPref());

  /// [Navigation]
  sl.registerLazySingleton<NavigationService>(() => NavigationServiceImpl());
}
