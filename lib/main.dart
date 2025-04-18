// ignore_for_file: must_be_immutable
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kashinfo/firebase_options.dart';
import 'package:kashinfo/model/local/local_user_model.dart';
import 'package:kashinfo/modules/auth/user_auth_screen.dart';
import 'package:kashinfo/modules/onboarding/onboarding.dart';
import 'package:kashinfo/modules/onboarding/onboarding_controller.dart';
import 'package:kashinfo/modules/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(LocalUserModelAdapter());
  await Hive.openBox<LocalUserModel>('userBox');

  runApp(Start());
}

class Start extends StatelessWidget {
  Start({super.key});
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Lexend'),
      home: SplashScreenWithNavigation(),
    );
  }
}

class SplashScreenWithNavigation extends StatefulWidget {
  @override
  _SplashScreenWithNavigationState createState() =>
      _SplashScreenWithNavigationState();
}

class _SplashScreenWithNavigationState
    extends State<SplashScreenWithNavigation> {
  final OnboardingController onboardingController = Get.find();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Show splash for 3 sec

    if (onboardingController.isOnboardingDone) {
      Get.off(() => UserAuthScreen());
    } else {
      Get.off(() => OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
