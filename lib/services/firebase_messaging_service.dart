import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FireBaseMessagingService{

  FireBaseMessagingService._();


  static FireBaseMessagingService fireBaseMessaging = FireBaseMessagingService._();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if(settings.authorizationStatus != AuthorizationStatus.authorized)
      {
        await  requestPermission();
      }
    else if(settings.authorizationStatus ==  AuthorizationStatus.authorized)
      {
        Get.snackbar('Notification Approved', 'approved');
      }
  }

  Future<void> getDeviceToken()
  async {
    String? token = await messaging.getToken();
    log(token!);
  }

}