import 'package:get_it/get_it.dart';

import '../pages/home/page_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<PageManager>( () => PageManager() );
}