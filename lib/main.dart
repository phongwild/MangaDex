import 'dart:async';
import 'dart:io';

import 'package:app/common/utils/app_connection_utils.dart';
import 'package:app/core/app_log.dart';
// import 'package:app/core/cache/shared_prefs.dart';
import 'package:app/core_ui/app_theme.dart/app_theme.dart';
import 'package:app/feature/cubit/user_cubit.dart';
import 'package:app/feature/utils/cached_manage_app.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // Optimize error handling
  if (!kReleaseMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };
  }

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Disable debug flags for better performance
    if (kReleaseMode) {
      debugProfileBuildsEnabled = false;
      debugPaintSizeEnabled = false;
    }

    // Run initialization tasks in parallel for faster startup
    await Future.wait([
      di.init(),
      clearImageCacheIfNeeded(),
      ConnectionUtils().init(),
      IsLogin.getInstance().loadSession(),
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    ]);
    
    AppTheme().changeTheme(TypeTheme.light);
    disableErrorWidget();
    HttpOverrides.global = CustomHttpOverrides();

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
    if (!kReleaseMode) {
      dlog('❎ ERROR OTHER   :$error');
      dlog('❎ STACKTRACE    :$stackTrace');
    }
  });
}

/// [disable error] widget when [release mode]
void disableErrorWidget() {
  if (kReleaseMode) {
    ErrorWidget.builder = (details) {
      return const SizedBox.shrink();
    };
  }
}
