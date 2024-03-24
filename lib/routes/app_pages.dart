import 'package:get/get.dart';
import 'package:radioplenitudesvie/pages/home/home_binding.dart';
import 'package:radioplenitudesvie/pages/video_screen/video_screen_view.dart';

import '../pages/dashboard/dashboard_binding.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/splash_screen/splash_screen_binding.dart';
import '../pages/splash_screen/splash_screen_view.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH_SCREEN;
  static var list = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const VideoListScreen(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
  ];
}
