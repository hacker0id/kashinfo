import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/model/local/local_user_model.dart';
import 'package:kashinfo/modules/auth/user_auth_screen.dart';
import 'package:kashinfo/modules/homescreen/homescreen.dart';
import 'package:kashinfo/modules/onboarding/onboarding_controller.dart';

class AuthController extends GetxController {
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OnboardingController onboardingController = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _facebookAuth = FirebaseAuth.instance;

  // Reactive user model using LocalUserModel
  var userModel = Rx<LocalUserModel?>(null);
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (image != null) {
      selectedImage = File(image.path);
      update(); // Update UI
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void clearAuthFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future<void> createOrLoginUser(String email, String password) async {
    final box = await Hive.openBox<LocalUserModel>('userBox');

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: AppColors.orange)),
        barrierDismissible: false,
      );

      // Check if user exists using sign-in first
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          await _handleUserLogin(userCredential.user!);
          return;
        }
      } catch (_) {
        // If user not found, create one
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          await _handleUserLogin(userCredential.user!, isNewUser: true);
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred',
        backgroundColor: AppColors.orange,
        colorText: Colors.black,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'Unexpected error occurred: ${e.toString()}',
        backgroundColor: AppColors.orange,
        colorText: Colors.black,
      );
    }
  }

  Future<void> _handleUserLogin(User user, {bool isNewUser = false}) async {
    final box = Hive.box<LocalUserModel>('userBox');
    final userData = LocalUserModel(
      email: user.email!,
      name: user.displayName ?? nameController.text.trim(),
      photoUrl: user.photoURL ?? null,
    );

    // Save user to Hive
    await box.put('userData', userData);
    userModel.value = userData;

    Get.back();
    if (isNewUser) {
      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: AppColors.orange,
        colorText: Colors.black,
      );
    } else {
      Get.snackbar(
        'Welcome Back',
        'Successfully signed in!',
        backgroundColor: AppColors.orange.withOpacity(0.7),
        colorText: Colors.black,
      );
    }
    onboardingController.isOnboardingDone = true;
    Get.offAll(() => HomeScreen());
    clearAuthFields();
  }

  // Future<void> loginWithFacebook() async {
  //   try {
  //     // Show loading indicator
  //     Get.dialog(
  //       const Center(child: CircularProgressIndicator()),
  //       barrierDismissible: false,
  //     );

  //     // Trigger Facebook Login
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     if (result.status == LoginStatus.success) {
  //       // Get access token
  //       final AccessToken accessToken = result.accessToken!;

  //       // Create Firebase credential
  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(accessToken.token);

  //       // Sign in to Firebase
  //       UserCredential userCredential =
  //           await _facebookAuth.signInWithCredential(credential);

  //       // Hide loading
  //       Get.back();

  //       if (userCredential.user != null) {
  //         Get.snackbar(
  //           'Success',
  //           'Logged in successfully!',
  //           backgroundColor: AppColors.orange,
  //           colorText: Colors.white,
  //         );
  //         Get.offAll(() => HomeScreen()); // Navigate to home screen
  //       }
  //     } else {
  //       Get.back();
  //       Get.snackbar(
  //         'Error',
  //         'Facebook login failed',
  //         backgroundColor: AppColors.orange,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     Get.back();
  //     Get.snackbar(
  //       'Error',
  //       'Unexpected error: ${e.toString()}',
  //       backgroundColor: AppColors.orange,
  //       colorText: Colors.white,
  //     );
  //     debugPrint('================> EXCEPTION : ${e.toString()}');
  //   }
  // }

  void _loadUserData() async {
    var box = await Hive.openBox<LocalUserModel>('userBox');
    userModel.value = box.get('userData');
    if (userModel.value != null) {
      debugPrint('User Loaded: ${userModel.value!.name}');
    } else {
      debugPrint('No user found in Hive');
    }
  }

  Future<void> _saveUserData(LocalUserModel user) async {
    var box = await Hive.openBox<LocalUserModel>('userBox');
    await box.put('userData', user);
    userModel.value = user;
  }

  Future<void> signInWithGoogle() async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.orange,
          ),
        ),
        barrierDismissible: false,
      );
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        Get.snackbar('Login Cancelled', 'Sign-in process was not completed.');
        Get.back();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Convert to LocalUserModel and save to Hive
      final userData = LocalUserModel.fromFirebaseUser(userCredential.user);
      userModel.value = userData;
      await _saveUserData(userData);
      Get.back();
      onboardingController.isOnboardingDone = true;
      Get.offAll(() => HomeScreen());
      clearAuthFields();

      Get.snackbar(
        'Login Successful',
        'Welcome ${userData.name}',
        backgroundColor: AppColors.orange.withOpacity(0.7),
        colorText: Colors.black,
      );
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      Get.snackbar('Error', e.toString());
      Get.back();
    }
  }

  Future<void> signOut() async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: AppColors.orange,
          ),
        ),
        barrierDismissible: false,
      );
      Future.delayed(Duration(seconds: 2), () async {
        await _auth.signOut();
        await _googleSignIn.signOut();
        userModel.value = null;

        // Clear user data from Hive
        var box = await Hive.openBox<LocalUserModel>('userBox');
        await box.delete('userData');

        Get.back();
        if (emailController.text.isNotEmpty) {
          clearAuthFields();
        }
        Get.offAll(() => UserAuthScreen());
        Get.snackbar('Signed Out', 'You have successfully signed out.',
            backgroundGradient: LinearGradient(colors: [
              AppColors.orange.withOpacity(0.9),
              AppColors.pink.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.topRight));
      });
    } catch (e) {
      Get.back();
      Get.snackbar('Error Occurred', '${e.toString()}');
    }
  }
}
