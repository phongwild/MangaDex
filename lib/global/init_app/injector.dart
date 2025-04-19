import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:app/global/init_app/initialize_dependencies.dart';
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
}
