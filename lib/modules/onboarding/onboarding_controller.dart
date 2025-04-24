import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  bool? isOnboardingDone;

  onboardingComplete() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('isOnboardingDone', true);
    debugPrint(
        '-------> Onboarding Screen -------> isOnboardingDone set to TRUE');
  }

  isOnboardingComplete() async {
    var prefs = await SharedPreferences.getInstance();

    isOnboardingDone = prefs.getBool('isOnboardingDone')!;
    debugPrint(
        '--------------> Onboarding Screen ------> isOnboarding ---> $isOnboardingDone');
    return isOnboardingDone;
  }
}
