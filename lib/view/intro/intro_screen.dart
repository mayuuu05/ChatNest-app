import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElasticIn(
                    child: Text(
                      'WELCOME TO',
                      style: TextStyle(
                        color: Color(0xff1e2a38),
                        fontSize: screenWidth * 0.09,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  ElasticIn(
                    child: Text(
                      'CHETNEST',
                      style: TextStyle(
                        color: Color(0xff1e2a38),
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Take our words for it.',
                    style: TextStyle(
                      color: Color(0xff1e2a38),
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/intro.png',
                      height: screenHeight * 0.35,
                      width: screenWidth * 0.7,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.41),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/in');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1e2a38),
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.010),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: IconButton(onPressed: () {
                      Get.toNamed('/in');
                    }, icon: Icon(Icons.arrow_forward_outlined,color: Colors.white,)),

                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Color(0xff1e2a38),
                          fontSize: screenWidth * 0.04,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}