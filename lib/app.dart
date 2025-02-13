import 'package:app/feature/router/nettromdex_router.dart';
import 'package:flutter/material.dart';
import 'package:app/global/l10n/gen/app_localizations.dart';
import 'package:app/global/router/app_route_observer/app_page_route_observer.dart';
import 'package:app/global/router/router.dart';
import 'global/router/app_route_observer/route_observer.dart';
import 'global/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetTromDex',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi', 'VN'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 246, 70, 219)),
        useMaterial3: false,
      ),
      navigatorObservers: [
        sl.get<AppRouteObserver>(),
        sl.get<AppPageRouteObserver>(),
      ],
      navigatorKey: navigation.navigatorKey,
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
