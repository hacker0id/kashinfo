import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/vendors/vendor_model.dart';

class VendorController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Vendor> vendors = <Vendor>[].obs;
  RxBool isLoading = true.obs;

// @override
//   onInit(){
//     super.onInit();

// // fetchVendorByDoc(vendorType ?? '');
//   }

  Future<void> fetchVendorByDoc(String vendorType) async {
    try {
      isLoading.value = true;

      final snapshot =
          await FirebaseFirestore.instance.collection(vendorType).get();

      vendors.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return Vendor.fromMap(data);
      }).toList();

      print('---------> Vendors :$vendors');
    } catch (e) {
      print('Error fetching vendors: $e');
      vendors.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // void fetchVendorByDoc(String cat) async {
  //   try {
  //     isLoading.value = true;
  //     DocumentSnapshot documentSnapshot =
  //         await firestore.collection('vendors').doc(cat).get();

  //     if (documentSnapshot.exists) {
  //       final data = documentSnapshot.data() as Map<String, dynamic>;
  //       print("Medics Data: $data");

  //       // Convert the data to Vendor Model if needed
  //       vendors.value = [Vendor.fromMap(data)];
  //     } else {
  //       print("No such document exists!");
  //       vendors.clear();
  //     }
  //   } catch (e) {
  //     print("Error fetching document: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> addVendor(
      String vendorType, Map<String, dynamic> vendorData) async {
    await FirebaseFirestore.instance
        .collection(vendorType)
        // .doc(vendorId)
        // .collection('medics')
        .add(vendorData);
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> makeSMS(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void openWhatsApp(String phoneNumber, {String message = ""}) async {
    final Uri whatsappUri = Uri.parse(
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch WhatsApp";
    }
  }
}
