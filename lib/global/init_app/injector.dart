import 'package:app/global/init_app/initialize_dependencies.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../common/utils/app_connection_utils.dart';
import '../../core_ui/app_theme.dart/app_theme.dart';
import '../../feature/utils/cached_manage_app.dart';
import '../../feature/utils/is_login.dart';
import '../../feature/utils/translate_lang.dart';
import 'initialize_core.dart';

final sl = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future init() async {
  await injectCore();
  await initializeDependencies();
  await Future.delayed(const Duration(seconds: 1));
  await clearImageCacheIfNeeded();
  await ConnectionUtils().init();
  AppTheme().changeTheme(TypeTheme.light);
  await TranslateLang().init();
  await IsLogin.getInstance().loadSession();
}
