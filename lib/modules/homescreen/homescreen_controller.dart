import 'package:get/get.dart';
import 'package:kashinfo/constants/strings.dart';

import 'package:kashinfo/modules/vendors/vendor_screen.dart';

class HomescreenController extends GetxController {
  RxInt tappedIndex = (0).obs;

// HANDLE TAP NAVIGATION
  void toggleIndex(int index) {
    tappedIndex.value = (tappedIndex.value == index) ? 0 : index;
    print(tappedIndex.value);

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
      //‪+880 1987‑968259‬