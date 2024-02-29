import 'package:get/get.dart';

import '../../routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 2000));
    Get.toNamed(AppRoutes.DASHBOARD);
  }
}


