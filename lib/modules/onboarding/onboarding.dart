import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/modules/auth/user_auth_screen.dart';
import 'package:kashinfo/modules/onboarding/onboarding_controller.dart';
import 'package:kashinfo/widgets/button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

double? deviceHeight;
double? deviceWidth;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  OnboardingController onboardingController = Get.put(OnboardingController());
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'findContacts',
      'title': 'Find Contacts Instantly!',
      'subtitle':
          'Search for vendors and access their contact details, address, and more—quickly and easily.',
    },
    {
      'image': 'nearBy',
      'title': 'Find Nearby Vendors!',
      'subtitle':
          'Easily locate vendors near you and get their contact information in one tap.',
    },
    {
      'image': 'easyContact',
      'title': 'Easily Contact Vendors!',
      'subtitle':
          'Only trusted and verified vendors are listed to ensure a seamless experience.',
    },
    {
      'image': 'findServices',
      'title': 'Be a Contributor!',
      'subtitle': 'Add vendor details and help others find them .',
    },
  ];

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.sizeOf(context).height;
    deviceWidth = MediaQuery.sizeOf(context).width;

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
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return pageViewChild(
                      context,
                      onboardingData[index]['image']!,
                      onboardingData[index]['title']!,
                      onboardingData[index]['subtitle']!,
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: deviceHeight! * 0.05),
                child: SmoothPageIndicator(
                  controller: controller,
                  count: onboardingData.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.black54,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: deviceHeight! * 0.08),
                child: Button(
                  text: currentPage == onboardingData.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: () {
                    if (currentPage < onboardingData.length - 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      onboardingController.onboardingComplete();
                      Get.to(UserAuthScreen());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageViewChild(
      BuildContext context, String imageName, String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth! * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/$imageName.png',
            height: deviceHeight! * 0.4,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
