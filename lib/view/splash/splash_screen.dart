import 'package:chatting_application/view/authentication/auth_manager.dart';
import 'package:chatting_application/view/intro/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff11171d),
        body: AnimatedSplashScreen(
          duration:4000,
          splash: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.06),
                Image.asset(
                  'assets/images/aaa.png',
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.3,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
                Text(
                  'ChatNest',
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'Where Bonds Are Best',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          nextScreen: AuthManager(),
          splashTransition: SplashTransition.fadeTransition,
          splashIconSize: screenHeight * 0.5,
          backgroundColor: Colors.transparent,

        ),
      ),
    );
  }
}