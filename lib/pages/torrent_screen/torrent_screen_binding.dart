import 'package:get/get.dart';

import 'torrent_screen_controller.dart';

class TorrentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TorrentScreenController>(
      () => TorrentScreenController(),
    );
  }
}
