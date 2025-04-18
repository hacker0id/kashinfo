import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/modules/auth/auth_controller.dart';
import 'package:kashinfo/modules/homescreen/homescreen.dart';
import 'package:kashinfo/modules/onboarding/onboarding.dart';
import 'package:kashinfo/widgets/button.dart';
import 'package:kashinfo/widgets/circle_icon_button.dart';
import 'package:kashinfo/widgets/custom_text_field.dart';

class UserAuthScreen extends StatelessWidget {
  UserAuthScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [AppColors.orange, AppColors.pink],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth! * 0.1,
                vertical: deviceHeight! * 0.015),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: MediaQuery.of(context).viewInsets.bottom > 0
                    ? BouncingScrollPhysics()
                    : NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    GetBuilder<AuthController>(builder: (_) => userAvatar()),
                    SizedBox(height: deviceHeight! * 0.07),

                    /// **Name Field**
                    CustomTextField(
                      controller: authController.nameController,
                      hintText: 'Enter Name',
                      icon: FontAwesomeIcons.userPen,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Name cannot be empty'
                          : null,
                    ),
                    SizedBox(height: deviceHeight! * 0.045),

                    /// **Email Field**
                    CustomTextField(
                      controller: authController.emailController,
                      hintText: 'Enter Email',
                      icon: FontAwesomeIcons.solidEnvelope,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Email cannot be empty'
                          : null,
                    ),
                    SizedBox(height: deviceHeight! * 0.045),

                    /// **Password Field**
                    CustomTextField(
                      controller: authController.passwordController,
                      hintText: 'Enter Password',
                      icon: FontAwesomeIcons.key,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Password cannot be empty'
                          : null,
                    ),

                    SizedBox(height: deviceHeight! * 0.045),
                    Row(
                      children: [
                        Expanded(
                            child:
                                Divider(thickness: 2, color: Colors.white70)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  10), // Space between dividers and text
                          child: Text(
                            "OR",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                            child:
                                Divider(thickness: 2, color: Colors.white70)),
                      ],
                    ),
                    SizedBox(height: deviceHeight! * 0.045),

                    /// **Social Login Buttons**
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          color: Colors.transparent,
                          elevation: 3,
                          shape: CircleBorder(),
                          child: CircleButton(
                            iconData: FontAwesomeIcons.google,
                            onTap: () {
                              debugPrint('--------> SignIn With Google Tapped');
                              authController.signInWithGoogle();
                            },
                            text: '',
                          ),
                        ),
                        if (GetPlatform.isIOS)
                          Card(
                            color: Colors.transparent,
                            elevation: 3,
                            shape: CircleBorder(),
                            child: CircleButton(
                              iconData: FontAwesomeIcons.apple,
                              onTap: () {},
                              text: '',
                            ),
                          ),
                        Card(
                          color: Colors.transparent,
                          elevation: 3,
                          shape: CircleBorder(),
                          child: CircleButton(
                            iconData: FontAwesomeIcons.facebook,
                            onTap: () {
                              debugPrint('--------->>>>>>> Facebook Tapped');
                              // Get.find<AuthController>().loginWithFacebook();
                            },
                            text: '',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: deviceHeight! * 0.02),

                    /// **Continue Button**
                    Button(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          debugPrint('=======+> Continue Tapped');
                          await authController.createOrLoginUser(
                              authController.emailController.text.trim(),
                              authController.passwordController.text.trim());
                        }
                      },
                      text: 'Continue',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget userAvatar() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [AppColors.pink, AppColors.orange],
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 85,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80,
              child: Get.find<AuthController>().selectedImage == null
                  ? Icon(FontAwesomeIcons.userLarge,
                      size: 65, color: AppColors.pink)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.file(
                        Get.find<AuthController>().selectedImage!,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 3,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: [AppColors.pink, AppColors.orange],
              ),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 25,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: IconButton(
                  onPressed: () => Get.find<AuthController>().pickImage(),
                  icon: Icon(FontAwesomeIcons.camera),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
