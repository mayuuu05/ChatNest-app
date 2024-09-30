import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  void toggleTheme(bool isDarkMode) {
    themeMode.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    update();
  }


  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    } else {
      return themeMode.value == ThemeMode.dark;
    }
  }


  void useSystemTheme() {
    themeMode.value = ThemeMode.system;
    update();
  }
}
