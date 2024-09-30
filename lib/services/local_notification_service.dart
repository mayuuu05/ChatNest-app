import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
class LocalNotificationService {
  LocalNotificationService._();

  static LocalNotificationService notificationService =
      LocalNotificationService._();
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();


  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'Chat app',
    'Local notification',
    importance: Importance.max,
    priority: Priority.high,
  );


  Future<void> initNotificationService() async {
    plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    AndroidInitializationSettings android =
        AndroidInitializationSettings('mipmap/ic_launcher');
    DarwinInitializationSettings iOS = DarwinInitializationSettings();

    InitializationSettings settings =
        InitializationSettings(android: android, iOS: iOS);
    await plugin.initialize(settings);
  }

  void showNotification(String title, String body) {

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    plugin.show(0, title, body, notificationDetails);
  }

  Future<void> scheduleNotification() async {

    tz.Location location = tz.getLocation('Asia/Kolkata');
    await plugin.zonedSchedule(
      0,
      'scheduled title',
      'scheduled body',
      tz.TZDateTime.now(location).add(const Duration(seconds: 5)),
      NotificationDetails(
        android: androidDetails
      ),
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime
    );
  }
}
