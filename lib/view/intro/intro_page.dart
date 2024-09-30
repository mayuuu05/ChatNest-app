import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff11171d),
        body: Column(
          children: [
            Container(
              height: screenHeight * 0.47,
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Positioned(
                    top: screenHeight * 0.05,
                    left: screenWidth * 0.1,
                    child: messageBubble(
                      context,
                      text: "Heyyyyy!🙋‍♀️\nNice to hear from you.",
                      color: Color(0xffF6A623),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.17,
                    right: screenWidth * 0.1,
                    child: messageBubble(context,
                        text: "And you, too!😉", color: Colors.white),
                  ),
                  Positioned(
                    top: screenHeight * 0.26,
                    left: screenWidth * 0.1,
                    child: messageBubble(
                      context,
                      text: "Let's meet? 📅 on 23rd Nov",
                      color: Color(0xffF6A623),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.35,
                    right: screenWidth * 0.1,
                    child: messageBubble(context,
                        text: "👍 See you!", color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: screenHeight * 0.3,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#ChatNest ',
                          style: TextStyle(
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Image.asset(
                          'assets/images/9640bea0b361a039d647faa5dbcb6771-removebg-preview.png',
                          height: 40,
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Chat, Share, and Feel Connected!\n\n',
                            style: TextStyle(
                              fontSize: screenWidth * 0.046,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Stay in touch with loved ones, friends, and colleagues like never before. Wherever life takes you, your conversations follow.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.050,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/signin');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.3,
                                vertical: screenHeight * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Color(0xff11171d),
                            ),
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/signin');
                            },
                            child: Text(
                              'I already have an account.',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageBubble(BuildContext context,
      {required String text, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.045,
          color: Colors.black,
        ),
      ),
    );
  }
}
