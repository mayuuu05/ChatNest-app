import 'package:get/get.dart';

class CheckBoxController extends GetxController{

  var isAgree = false.obs;
  void toggleAgree() {
    isAgree.value = !isAgree.value;
  }

}