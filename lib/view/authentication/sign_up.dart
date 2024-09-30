import 'package:chatting_application/model/user_model.dart';
import 'package:chatting_application/services/cloud_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/checkBox_controller.dart';
import '../../controller/theme_controller.dart';
import '../../services/auth_service.dart';
import '../../services/google_auth_service.dart';

class SignupPage extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final CheckBoxController checkBoxController = Get.put(CheckBoxController());

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    var mediaQuery = MediaQuery.of(context);
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;
    double horizontalPadding = screenWidth > 600 ? 100.0 : 30.0;
    bool isDarkMode = themeController.isDarkMode;
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
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Center(
                    child: Image.asset(
                      'assets/images/group-chat-concept-illustration_114360-3429.png',
                      height: screenHeight * 0.2,
                    )),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Create New Account',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e2a38),
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildTextField('Name', controller.txtName),
                        SizedBox(height: 8),
                        _buildTextField('Email', controller.txtEmail),
                        SizedBox(height: 8),
                        _buildTextField('Password', controller.txtPassword,
                            obscureText: true),
                        SizedBox(height: 8),
                        _buildTextField(
                            'Confirm Password', controller.txtConfirmPassword,
                            obscureText: true),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Obx(() => Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.green[900],
                              value: checkBoxController.isAgree.value,
                              onChanged: (value) {
                                checkBoxController.toggleAgree();
                              },
                            )),
                            GestureDetector(
                              onTap: checkBoxController.toggleAgree,
                              child: Text(
                                'I agree with Terms & Conditions',
                                style: TextStyle(
                                  color: Color(0xff1e2a38),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Obx(() => ElevatedButton(
                          onPressed: checkBoxController.isAgree.value
                              ? () async {
                            if (controller.txtPassword.text ==
                                controller.txtConfirmPassword.text) {
                              await AuthService.authService
                                  .signUptWithEmailAndPassword(
                                  controller.txtEmail.text,
                                  controller.txtPassword.text);

                              UserModel user = UserModel(
                                  name: controller.txtName.text,
                                  email: controller.txtEmail.text,
                                  image:
                                  "https://media.istockphoto.com/id/2015429231/vector/vector-flat-illustration-in-black-color-avatar-user-profile-person-icon-profile-picture.jpg?s=612x612&w=0&k=20&c=Wu70OARg2npxWy5E22_ZLneabuTafvV_6avgYPhWOoU=",
                                  phone: controller.txtPhone.text,
                                  token: "--");
                              CloudFireStoreServices
                                  .cloudFireStoreServices
                                  .insertUserIntoFireStore(user);
                              Get.back();
                              controller.txtEmail.clear();
                              controller.txtPassword.clear();
                              controller.txtConfirmPassword.clear();
                              controller.txtName.clear();
                            }
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff1e2a38),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth > 600 ? 80 : 50,
                              vertical: 15,
                            ),
                          ),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/signin');
                          },
                          child: Text(
                            'Already have an account? Sign In',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff1e2a38),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          '------------- Or continue with -----------',
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialLoginButton(
                                'assets/images/google.png', 'Google',
                                onTap: () async {
                                  await GoogleAuthService.googleAuthService
                                      .signInWithGoogle();
                                  User? user =
                                  AuthService.authService.getCurrentUser();
                                  if (user != null) {
                                    Get.offAndToNamed('/home');
                                  }
                                }),
                            SizedBox(width: 15),
                            _buildSocialLoginButton(
                                'assets/images/facebook.png', 'Facebook',
                                onTap: () {
                                  // Add Facebook login logic here
                                }),
                            SizedBox(width: 15),
                            _buildSocialLoginButton(
                                'assets/images/apple.png', 'Apple', onTap: () {
                              // Add Apple login logic here
                            }),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
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

  Widget _buildTextField(String label, controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      cursorColor: Colors.grey,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black12,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

Widget _buildSocialLoginButton(String iconPath, String label,
    {required Function onTap}) {
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
