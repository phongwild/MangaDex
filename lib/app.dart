import 'dart:async';

import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:app/global/l10n/gen/app_localizations.dart';
import 'package:app/global/router/app_route_observer/app_page_route_observer.dart';
import 'package:app/global/router/router.dart';
import 'common/utils/app_connection_utils.dart';
import 'global/router/app_route_observer/route_observer.dart';
import 'global/router/app_router.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final ConnectionUtils connectionUtils = ConnectionUtils();
  Timer? toastTimer;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupNetworkListener();
    });
  }

  void setupNetworkListener() {
    connectionUtils.init();
    connectionUtils.addListener(onNetworkChanged, addLastEvent: true);
  }

  void onNetworkChanged(bool isActive) {
    if (!isActive) {
      // Hiển thị toast khi mất mạng
      if (toastTimer != null) return;
      toastTimer?.cancel();
      toastTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
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
      showToast('Kết nối internet thành công >.<');
    }
  }

  @override
  void dispose() {
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
      navigatorObservers: [
        sl.get<AppRouteObserver>(),
        sl.get<AppPageRouteObserver>(),
      ],
      navigatorKey: navigatorKey,
      initialRoute: NettromdexRouter.bottomNav,
      onGenerateRoute: (settings) =>
          _generateRoute(routes: AppRouter().router, settings: settings),
    );
  }

  Route<dynamic>? _generateRoute({
    required List<RouterModule> routes,
    required RouteSettings settings,
  }) {
    final routesMap = <String, PageRoute>{};
    for (final route in routes) {
      routesMap.addAll(route.getRoutes(settings));
    }
    return routesMap[settings.name];
  }
}
