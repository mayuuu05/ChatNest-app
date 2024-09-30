import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  RxString receiverEmail = "".obs;
  RxString receiverName = "".obs;
  RxString receiverImage = "".obs;
  RxString image = "".obs;

  RxString chatMessage = ''.obs;
  RxString callId = ''.obs;
  List<int> selectedMessages = [];
  TextEditingController txtMessage = TextEditingController();
  TextEditingController txtUpdateMessage = TextEditingController();

  void getReceiver(String email, String name,String image) {
    receiverEmail.value = email;
    receiverName.value = name;
    receiverImage.value = image;
  }


  var isMessageEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    txtMessage.addListener(() {
      isMessageEmpty.value = txtMessage.text.trim().isEmpty;
    });
  }

  void getImage(String url)
  {
    image.value = url;
  }
}
