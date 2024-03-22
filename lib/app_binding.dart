import 'package:get/get.dart';

import 'api/api-provider.dart';
import 'api/radio_web_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.put(RadioWebAPI(), permanent: true);
    Get.put(RadioWebService(), permanent: true);
  }
}