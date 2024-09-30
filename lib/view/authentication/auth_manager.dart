
import 'package:chatting_application/view/home/home_screen.dart';
import 'package:chatting_application/view/intro/intro_screen.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';


class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getCurrentUser() == null)
        ?  IntroScreen()
        :  HomeScreen();
  }
}