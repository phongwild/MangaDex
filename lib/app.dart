import 'dart:async';

import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:app/global/l10n/gen/app_localizations.dart';
import 'package:app/global/router/app_route_observer/app_page_route_observer.dart';
import 'package:app/global/router/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'common/utils/app_connection_utils.dart';
import 'global/router/app_route_observer/route_observer.dart';
import 'global/router/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // This widget is the root of your application.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ConnectionUtils connectionUtils = ConnectionUtils();
  Timer? toastTimer;
  bool _lastNetworkState = true;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupNetworkListener();
    });
  }

  void setupNetworkListener() {
    connectionUtils.init();
    connectionUtils.addListener(onNetworkChanged, addLastEvent: true);
  }

  void onNetworkChanged(bool isActive) {
    // Avoid unnecessary state changes and toasts
    if (_lastNetworkState == isActive) return;
    _lastNetworkState = isActive;
    
    if (!isActive) {
      // Optimize toast frequency for low-end devices
      if (toastTimer != null) return;
      toastTimer?.cancel();
      toastTimer = Timer.periodic(const Duration(seconds: 8), (timer) { // Increased interval
        if (!connectionUtils.isActive) {
          showToast('Không có kết nối mạng! :(((', isError: true);
        } else {
          toastTimer?.cancel();
          toastTimer = null;
        }
      });
    } else {
      toastTimer?.cancel();
      toastTimer = null;
      // Only show success toast if we were previously disconnected
      showToast('Kết nối internet thành công >.<');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Pause network monitoring when app is not active to save resources
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      toastTimer?.cancel();
      toastTimer = null;
    } else if (state == AppLifecycleState.resumed) {
      // Re-check network state when app resumes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onNetworkChanged(connectionUtils.isActive);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    connectionUtils.removeListener(onNetworkChanged);
    connectionUtils.dispose();
    toastTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'NetTromDex',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi', 'VN'),
      debugShowCheckedModeBanner: false,
      // Optimize navigator observers for performance
      navigatorObservers: kReleaseMode ? [
        sl.get<AppRouteObserver>(),
      ] : [
        sl.get<AppRouteObserver>(),
        sl.get<AppPageRouteObserver>(),
      ],
      navigatorKey: navigatorKey,
      initialRoute: NettromdexRouter.bottomNav,
      onGenerateRoute: (settings) =>
          _generateRoute(routes: AppRouter().router, settings: settings),
      // Add performance optimizations
      builder: (context, child) {
        // Optimize text scaling for low-end devices
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2)
            ),
          ),
          child: child!,
        );
      },
    );
  }

  Route<dynamic>? _generateRoute({
    required List<RouterModule> routes,
    required RouteSettings settings,
  }) {
    // Cache route map for better performance (avoid recreation)
    static Map<String, PageRoute>? _cachedRoutesMap;
    
    if (_cachedRoutesMap == null) {
      _cachedRoutesMap = <String, PageRoute>{};
      for (final route in routes) {
        _cachedRoutesMap!.addAll(route.getRoutes(settings));
      }
    }
    
    return _cachedRoutesMap![settings.name];
  }
}
