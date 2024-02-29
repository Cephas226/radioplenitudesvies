import 'package:get/get.dart';
import 'package:radioplenitudesvie/pages/planning_screen/planning_screen_controller.dart';

class PlanningScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanningScreenController>(
      () => PlanningScreenController(),
    );
  }
}
