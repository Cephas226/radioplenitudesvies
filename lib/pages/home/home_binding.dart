import 'package:get/get.dart';
import 'accueil_controller.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccueilController>(
      () => AccueilController(),
    );
  }
}
