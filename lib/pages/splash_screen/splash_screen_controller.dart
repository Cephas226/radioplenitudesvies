import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamedUntil('/', (route) => false);
    });
  }
}
