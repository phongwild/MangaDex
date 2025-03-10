import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/core/app_log.dart';
import 'package:overlay_support/overlay_support.dart';
import 'app.dart';
import 'core/http_override/custom_http_override.dart';
import 'global/init_app/injector.dart' as di;

/// [get the debug mode]
bool get isInDebugMode {
  bool isDebugMode = false;
  assert(isDebugMode = true);
  return isDebugMode;
}

/// [main]
Future<void> main() async {
  ///[cache some errors]
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (!kReleaseMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  ///[run app]
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();
    await Future.delayed(const Duration(seconds: 1));
    // await SharedPref.getInstance();
    // await TranslateLang().init();
    disableErrorWidget();
    // override http protocol
    HttpOverrides.global = CustomHttpOverrides();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(const OverlaySupport.global(
        child: MyApp(),
      ));
    });
  }, (error, stackTrace) {
    dlog('❎ ERROR OTHER   :$error');
    dlog('❎ STACKTRACE    :$stackTrace');
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
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
