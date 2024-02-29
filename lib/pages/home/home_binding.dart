import 'package:get/get.dart';
import 'package:radioplenitudesvie/pages/home/home_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
