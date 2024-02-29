import 'package:get/get.dart';
import 'package:radioplenitudesvie/pages/home/accueil_controller.dart';

import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<AccueilController>(() => AccueilController());
  }
}
