import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kashinfo/constants/strings.dart';
import 'package:kashinfo/modules/vendors/vendor_screen.dart';

class HomescreenController extends GetxController {
  RxInt tappedIndex = (0).obs;

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

// HANDLE TAP NAVIGATION
  void toggleIndex(int index) {
    tappedIndex.value = (tappedIndex.value == index) ? 0 : index;
    debugPrint('${tappedIndex.value}');

    if (tappedIndex == 0) {
      Get.to(VendorScreen(category: AppStrings.doct));
    } else if (tappedIndex == 1) {
      Get.to(VendorScreen(category: AppStrings.grocery));
    } else if (tappedIndex == 2) {
      Get.to(VendorScreen(category: AppStrings.shop));
    } else if (tappedIndex == 3) {
      Get.to(VendorScreen(category: AppStrings.travel));
    } else if (tappedIndex == 4) {
      Get.to(VendorScreen(category: AppStrings.serv));
    }
  }
}
