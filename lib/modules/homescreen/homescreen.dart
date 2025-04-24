// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/model/local/local_user_model.dart';
import 'package:kashinfo/modules/auth/auth_controller.dart';
import 'package:kashinfo/modules/homescreen/homescreen_controller.dart';
import 'package:kashinfo/modules/onboarding/onboarding.dart';
import 'package:kashinfo/modules/profile/profile_screen.dart';
import 'package:kashinfo/modules/vendors/add_vendor_screen.dart';
import 'package:kashinfo/widgets/circle_icon_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController searchBarController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  final HomescreenController controller = Get.put(HomescreenController());

  @override
  Widget build(BuildContext context) {
    final userModel = authController.userModel.value;
    if (userModel == null) {
      return const Center(
          child: CircularProgressIndicator(
        color: AppColors.orange,
      ));
    }

    return Scaffold(
      body: DraggableHome(
        expandedBody: Container(color: Colors.yellow, height: 200),
        headerExpandedHeight: 0.4,
        alwaysShowLeadingAndAction: false,
        leading: const SizedBox.shrink(),
        curvedBodyRadius: 30,
        appBarColor: AppColors.pink,
        title: Image(
          image: const AssetImage(
            'assets/images/light_logo.png',
          ),
          height: deviceHeight! * 0.065,
        ),
        headerWidget: headerWidget(userModel),
        backgroundColor: Colors.grey.shade200,
        body: [
          bodyWidget(),
        ],
      ),
    );
  }

  Widget headerWidget(LocalUserModel userModel) {
    return Container(
      color: AppColors.pink.withOpacity(1),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.pink,
                    radius: 35,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 33,
                      child: InkWell(
                        onTap: () => Get.to(UserProfileScreen()),
                        child: userModel.photoUrl != null
                            ? CircleAvatar(
                                backgroundColor: AppColors.orange,
                                radius: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.network(
                                    userModel.photoUrl!,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : authController.selectedImage != null
                                ? CircleAvatar(
                                    backgroundColor: AppColors.orange,
                                    radius: 30,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: Image.file(
                                        authController.selectedImage!,
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    FontAwesomeIcons.userLarge,
                                    size: 32,
                                    color: AppColors.pink,
                                  ),
                      ),
                    ),
                  ),
                  SizedBox(width: deviceWidth! * 0.05),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userModel.name ??
                            authController.nameController.text.trim(),
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        userModel.email ??
                            authController.emailController.text.trim(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          fontWeight: FontWeight.w200,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: deviceWidth! * 0.05),
                  CircleAvatar(
                    backgroundColor: AppColors.pink,
                    radius: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            await authController.signOut();
                          },
                          icon: const Icon(
                            FontAwesomeIcons.signOutAlt,
                            color: AppColors.pink,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: deviceHeight! * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleButton(
                    iconData: FontAwesomeIcons.plusCircle,
                    text: 'Add Vendor',
                    onTap: () {
                      Get.to(() => AddVendorScreen());
                    },
                  ),
                  CircleButton(
                    iconData: FontAwesomeIcons.remove,
                    text: 'Report Vendor',
                    onTap: () {},
                  ),
                  CircleButton(
                    iconData: FontAwesomeIcons.locationArrow,
                    text: 'Near By',
                    onTap: () {},
                  ),
                  CircleButton(
                    iconData: FontAwesomeIcons.heart,
                    text: 'Recents',
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: deviceHeight! * 0.045),
              SizedBox(
                width: deviceWidth! * 0.6,
                child: CupertinoSearchTextField(
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  style: TextStyle(
                    color: AppColors.pink,
                  ),
                  backgroundColor: Colors.white,
                  placeholder: 'Search Vendor',
                  placeholderStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.pink,
                  ),
                  prefixIcon: Icon(
                    FontAwesomeIcons.search,
                    color: AppColors.pink,
                  ),
                  prefixInsets: EdgeInsets.only(
                    left: deviceWidth! * 0.05,
                    right: deviceWidth! * 0.05,
                  ),
                  suffixIcon: Icon(
                    FontAwesomeIcons.xmark,
                    color: AppColors.pink,
                  ),
                  controller: searchBarController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyWidget() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(thickness: 2, color: AppColors.orange)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "TOP SEARCHES",
                style: TextStyle(
                    color: AppColors.orange, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(child: Divider(thickness: 2, color: AppColors.orange)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: deviceHeight! * 0.2,
            width: deviceWidth!,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
              ),
              items: buildCarouselItems(),
            ),
          ),
        ),
        SizedBox(height: deviceHeight! * 0.02),
        Row(
          children: [
            Expanded(child: Divider(thickness: 2, color: AppColors.orange)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "CATEGORIES",
                style: TextStyle(
                    color: AppColors.orange, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(child: Divider(thickness: 2, color: AppColors.orange)),
          ],
        ),
        SizedBox(height: deviceHeight! * 0.9, child: vendorCategories()),
      ],
    );
  }

  buildCarouselItems() {
    return List.generate(
      3,
      (int index) => ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          'assets/images/img${index + 1}.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget vendorCategories() {
    return GetBuilder<HomescreenController>(
      builder: (controller) => GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 16 / 4,
          crossAxisCount: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          bool isTapped = controller.tappedIndex.value == index;

          return InkWell(
            onTap: () => controller.toggleIndex(index),
            child: AnimatedScale(
              scale: isTapped ? 1 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.7),
                      AppColors.orange,
                      AppColors.pink,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(categoryIcons[index], size: 35, color: AppColors.pink),
                    const SizedBox(width: 20),
                    Text(
                      categoryNames[index],
                      style:
                          const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> categoryNames = [
    'Health',
    'Grocery',
    'Shopping',
    'Travel',
    'Services',
  ];

  List<IconData> categoryIcons = [
    FontAwesomeIcons.heartCirclePlus,
    FontAwesomeIcons.bowlRice,
    FontAwesomeIcons.bagShopping,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.gears,
  ];
}
