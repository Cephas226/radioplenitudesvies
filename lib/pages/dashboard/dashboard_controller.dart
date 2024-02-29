import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;
  List<IconData> iconList = [
    Icons.abc_sharp,
    Icons.access_time,
    Icons.holiday_village,
    Icons.account_tree_rounded
  ];
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }
}
