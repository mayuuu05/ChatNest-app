import 'package:chatting_application/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../services/google_auth_service.dart';

class SigninPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    var controller = Get.put(AuthController());
    double horizontalPadding = screenWidth > 600 ? 100.0 : 30.0;


    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.1),
                Center(
                  child: Image.asset(
                    'assets/images/tablet-login-concept-illustration_114360-7883.png',
                    height: screenHeight * 0.2,
                  ),
                ),
                SizedBox(height: 15,),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Login to your Account',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1e2a38),
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildTextField('Email',controller.txtEmail),
                          SizedBox(height: 15),
                          _buildTextField('Password', obscureText: true,controller.txtPassword),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () {
                              // Add forgot password logic
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xff1e2a38),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await AuthService.authService.makeAnAccountWithEmailAndPassword(controller.txtEmail.text, controller.txtPassword.text);
                              User? user = AuthService.authService.getCurrentUser();
                              if(user!= null)
                              {
                                Get.offAndToNamed('/home');
                                Get.snackbar(
                                    "Successful.....", "Thank you for join US!! ",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green);
                              }
                              else
                              {
                                Get.snackbar(
                                    'Sign in failed!!!',
                                    'Email or Password may be wrong!! Please check your password or email',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.red
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff1e2a38),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth > 600 ? 80 : 50,
                                vertical: 15,
                              ),
                            ),
                            child: Text(
                              'Log In',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/signup');
                            },
                            child: Text(
                              'Don\'t have an account? Sign Up',
                              style: TextStyle(
                                color: Color(0xff1e2a38),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),

                          Text(
                            '------------- Or continue with -----------',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialLoginButton('assets/images/google.png', 'Google', onTap: () async {
                                await GoogleAuthService.googleAuthService.signInWithGoogle();
                                User? user = AuthService.authService.getCurrentUser();
                                if(user != null) {
                                  Get.offAndToNamed('/home');
                                }
                              }),
                              SizedBox(width: 15),
                              _buildSocialLoginButton('assets/images/facebook.png', 'Facebook', onTap: () {

                              }),
                              SizedBox(width: 15),
                              _buildSocialLoginButton('assets/images/apple.png', 'Apple', onTap: () {
                              }),
                            ],
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginButton(String iconPath, String label, {required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Color(0xffeef1f7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, controller, {bool obscureText = false}) {
    return TextField(
      cursorColor: Colors.grey,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black12,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[600]
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
