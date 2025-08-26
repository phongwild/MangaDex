import 'dart:async';
import 'dart:io';

import 'package:app/common/utils/app_connection_utils.dart';
import 'package:app/core/app_log.dart';
import 'package:app/core/performance_optimizer.dart';
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
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (!kReleaseMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Disable debug features in production for better performance
    if (kReleaseMode) {
      debugProfileBuildsEnabled = false;
      debugPrintGestureArenaDiagnostics = false;
    }

    // Set device orientation early
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    
    // Optimize for low-end devices
    await PerformanceOptimizer.optimizeForLowEndDevice();
    
    // Initialize critical services first
    await di.init(); // Dependency injection
    
    // Optimize app initialization order for low-end devices
    final futures = <Future>[
      // Run these in parallel to reduce startup time
      IsLogin.getInstance().loadSession(),
      ConnectionUtils().init(),
    ];
    
    // Only clear cache if really needed (reduce startup time)
    if (!kReleaseMode) {
      futures.add(clearImageCacheIfNeeded());
    } else {
      // For low-end devices, optimize cache in background
      futures.add(optimizeCacheForLowEndDevice());
    }
    
    await Future.wait(futures);
    
    // Set theme and other UI configurations
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
                  // Defer profile loading to reduce initial load time
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    authCubit.getProfile();
                  });
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
      return const SizedBox.shrink(); // More efficient than Center()
    };
  }
}
