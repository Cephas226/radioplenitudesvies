import 'package:get_it/get_it.dart';

import '../provider/page_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<PageManager>( () => PageManager() );
}