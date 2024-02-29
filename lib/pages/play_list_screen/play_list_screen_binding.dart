import 'package:get/get.dart';
import 'package:radioplenitudesvie/pages/play_list_screen/play_list_screen_controller.dart';


class TorrentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayLlistScreenController>(
      () => PlayLlistScreenController(),
    );
  }
}
