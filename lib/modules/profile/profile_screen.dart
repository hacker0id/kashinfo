import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/helpers.dart';
import 'package:kashinfo/modules/auth/auth_controller.dart';
import 'package:kashinfo/modules/onboarding/onboarding.dart';
import 'package:kashinfo/widgets/button.dart';
import 'package:kashinfo/widgets/circle_icon_button.dart';
import 'package:kashinfo/widgets/custom_text_field.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(FontAwesomeIcons.chevronLeft),
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: deviceWidth! * 0.1,
              //vertical: deviceHeight! * 0.015,
            ),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  physics: MediaQuery.of(context).viewInsets.bottom > 0
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<AuthController>(
                            builder: (_) => userAvatar()),
                        SizedBox(height: deviceHeight! * 0.07),

                        /// **Name Field**
                        CustomTextField(
                          controller: authController.nameController,
                          hintText: 'Change Name',
                          icon: FontAwesomeIcons.userPen,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Name cannot be empty'
                              : null,
                        ),
                        SizedBox(height: deviceHeight! * 0.045),

                        /// **Password Field**
                        CustomTextField(
                          controller: authController.passwordController,
                          hintText: 'Change Password',
                          isPasswordField: true,
                          icon: FontAwesomeIcons.key,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Password cannot be empty'
                              : null,
                        ),

                        SizedBox(height: deviceHeight! * 0.045),

                        CustomTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm Password',
                          icon: FontAwesomeIcons.key,
                          isPasswordField: true,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Password cannot be empty'
                              : null,
                        ),

                        SizedBox(height: deviceHeight! * 0.045),

                        SizedBox(height: deviceHeight! * 0.02),

                        /// **Continue Button**
                        Button(
                          onPressed: () async {
                            // Validate all fields first
                            final isNameValid = Validator.validateInput(
                              fieldName: 'Name',
                              value: authController.nameController.text,
                              forbiddenValues: [
                                'Raakib',
                                'Mansha',
                                'admin',
                                'root'
                              ],
                              customError: 'These User Ids Are Reserved!',
                              maxLength: 10,
                              minLength: 3,
                            );

                            final isPasswordValid = Validator.validateInput(
                              fieldName: 'Password',
                              value: authController.passwordController.text,
                              maxLength: 32,
                              minLength: 8,
                            );
                            if (isNameValid) {
                              if (isPasswordValid) {
                                // ! REPLACE WITH UPDATE USER INFO FUNCTION

                                await authController.createOrLoginUser(
                                  authController.emailController.text.trim(),
                                  authController.passwordController.text.trim(),
                                );
                              }
                            }
                          },
                          text: 'Update',
                        ),
                      ],
                    ),
                  ),
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
              child: authController.userModel.value!.photoUrl != null
                  ? CircleAvatar(
                      backgroundColor: AppColors.orange,
                      radius: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.network(
                          authController.userModel.value!.photoUrl!,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Get.find<AuthController>().selectedImage == null
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
