import 'package:chatting_application/services/firebase_messaging_service.dart';
import 'package:chatting_application/services/local_notification_service.dart';
import 'package:chatting_application/view/authentication/auth_manager.dart';
import 'package:chatting_application/view/authentication/sign_in.dart';
import 'package:chatting_application/view/authentication/sign_up.dart';
import 'package:chatting_application/view/home/chat_page.dart';
import 'package:chatting_application/view/home/home_screen.dart';
import 'package:chatting_application/view/intro/intro_page.dart';
import 'package:chatting_application/view/profile/profile_edit.dart';
import 'package:chatting_application/view/profile/profile_setting.dart';
import 'package:chatting_application/view/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  await LocalNotificationService.notificationService.initNotificationService();

  await FireBaseMessagingService.fireBaseMessaging.requestPermission();
  await FireBaseMessagingService.fireBaseMessaging.getDeviceToken();
  runApp(const ChatNest());
}

class ChatNest extends StatelessWidget {
  const ChatNest({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen(),),
        GetPage(name: '/auth', page: () =>  AuthManager(),),


        GetPage(name: '/in', page: () => IntroPage(),transition :Transition.upToDown),
        GetPage(name: '/signin', page: () => SigninPage(),),
        GetPage(name: '/signup', page: () => SignupPage(),),
        GetPage(name: '/home', page: () => HomeScreen(),),
        GetPage(name: '/pf', page: () => ProfileSetting(),),
        GetPage(name: '/chat', page: () => ChatPage(),),
        GetPage(name: '/ed_Pf', page: () => ProfileEditPage(),),
      ],

    );
  }
}

