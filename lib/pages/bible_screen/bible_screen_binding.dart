import 'package:get/get.dart';
import 'package:radioplenitudesvie/pages/Bible_screen/Bible_screen_controller.dart';

class BibleScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BibleScreenController>(
      () => BibleScreenController(),
    );
  }
}
