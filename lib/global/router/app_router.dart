import 'package:app/feature/router/nettromdex_router.dart';
import 'package:get_it/get_it.dart';
import 'package:app/global/router/navigator.dart';

import 'router.dart';

final sl = GetIt.instance;

NavigationService navigation = sl.get<NavigationService>();

class AppRouter {
  final List<RouterModule> _routes = [];

  List<RouterModule> get router => _routes;

  AppRouter() {
    _routes.clear();
    _routes.add(NettromdexRouter());
    // _routes.add(HomeRouter());
    // _routes.add(AuthRouter());
    // _routes.add(TransferMoneyRouter());
    // _routes.add(TransMoneySubAccRouter());
  }
}
