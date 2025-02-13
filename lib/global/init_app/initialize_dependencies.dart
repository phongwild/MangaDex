import 'package:get_it/get_it.dart';
import 'package:app/global/router/app_route_observer/app_page_route_observer.dart';
import 'package:app/global/router/app_route_observer/route_observer.dart';

Future initializeDependencies() async {
  GetIt.instance.registerSingleton(AppRouteObserver());
  GetIt.instance.registerSingleton(AppPageRouteObserver());
  // GetIt.instance.registerSingleton(ThemeCubit());
  // GetIt.instance.registerSingleton(LocaleCubit());
}
