import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var tabIndex = 0.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }

  void changeTab(int index) {
    tabIndex.value = index;
    tabController.animateTo(index);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  var selectedIndex = 0.obs;

  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
