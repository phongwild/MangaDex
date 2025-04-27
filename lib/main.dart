import 'dart:async';
import 'dart:io';
import 'package:app/common/utils/app_connection_utils.dart';
// import 'package:app/core/cache/shared_prefs.dart';
import 'package:app/core_ui/app_theme.dart/app_theme.dart';
import 'package:app/feature/cubit/user_cubit.dart';
import 'package:app/feature/utils/cached_manage_app.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/app_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'app.dart';
import 'core/http_override/custom_http_override.dart';
import 'feature/cubit/auth_cubit.dart';
import 'global/init_app/injector.dart' as di;

/// [get the debug mode]
bool get isInDebugMode {
  bool isDebugMode = false;
  assert(isDebugMode = true);
  return isDebugMode;
}

/// [main]
Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (!kReleaseMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // debugProfileBuildsEnabled = true;
    // debugPaintSizeEnabled = true;

    await di.init(); // Chờ inject dependencies
    await Future.delayed(const Duration(seconds: 1));
    // await clearImageCacheIfNeeded();
    await ConnectionUtils().init();
    AppTheme().changeTheme(TypeTheme.light);
    // await SharedPref.init();
    await IsLogin.getInstance().loadSession();
    disableErrorWidget();
    HttpOverrides.global = CustomHttpOverrides();

    // Đảm bảo app chỉ chạy theo hướng dọc trước khi build UI
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    runApp(
      OverlaySupport.global(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                final authCubit = AuthCubit();
                if (IsLogin.getInstance().isLoggedIn) {
                  authCubit.getProfile();
                }
                return authCubit;
              },
            ),
            BlocProvider(create: (context) => UserCubit())
          ],
          child: const MyApp(),
        ),
      ),
    );
  }, (error, stackTrace) {
    dlog('❎ ERROR OTHER   :$error');
    dlog('❎ STACKTRACE    :$stackTrace');
  });
}

/// [disable error] widget when [release mode]
void disableErrorWidget() {
  if (kReleaseMode) {
    ErrorWidget.builder = (details) {
      return const Center();
    };
  }
}
