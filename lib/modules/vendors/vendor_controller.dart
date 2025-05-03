import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../model/vendors/vendor_model.dart';
import '../../screens/map_selection_screen.dart';

class VendorController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<Vendor> vendors = <Vendor>[].obs;
  RxBool isLoading = true.obs;
  RxBool isAddingVendor = false.obs;
  File? selectedImage;
  Map<String, double>? vendorLocation;
  DateTime? startDateTime;
  DateTime? endDateTime;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  var vImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    selectedImage = File(image.path);
                    update();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    selectedImage = File(image.path);
                    update();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getLocation() async {
    try {
      debugPrint('Starting location service...');
      Location locationService = Location();
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      // Check if location service is enabled
      serviceEnabled = await locationService.serviceEnabled();
      debugPrint('Location service enabled: $serviceEnabled');

      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        debugPrint('Requested location service: $serviceEnabled');
        if (!serviceEnabled) {
          Get.snackbar(
            'Error',
            'Location services are disabled. Please enable them to continue.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Check location permissions
      permissionGranted = await locationService.hasPermission();
      debugPrint('Location permission status: $permissionGranted');

      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await locationService.requestPermission();
        debugPrint('Requested location permission: $permissionGranted');
        if (permissionGranted != PermissionStatus.granted) {
          Get.snackbar(
            'Error',
            'Location permissions are required to select a location.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Get current location
      debugPrint('Getting current location...');
      final currentLocation = await locationService.getLocation();
      debugPrint(
          'Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');

      if (currentLocation.latitude == null ||
          currentLocation.longitude == null) {
        Get.snackbar(
          'Error',
          'Could not get current location. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Open map selection screen
      debugPrint('Opening map selection screen...');
      try {
        final selectedLocation = await Get.to<Map<String, double>?>(
          () => MapSelectionScreen(
            initialLocation: {
              'lat': currentLocation.latitude!,
              'long': currentLocation.longitude!,
            },
          ),
          fullscreenDialog: true,
        );
        debugPrint(
            'Map selection screen closed with result: $selectedLocation');

        if (selectedLocation != null) {
          debugPrint('Selected location: $selectedLocation');
          vendorLocation = selectedLocation;
          update();
        } else {
          debugPrint('No location selected');
        }
      } catch (e) {
        debugPrint('Error opening map selection screen: $e');
        Get.snackbar(
          'Error',
          'Could not open map selection screen: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Error in getLocation: $e');
      Get.snackbar(
        'Error',
        'An error occurred while getting location: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> selectDateTime() async {
    // Select Start Date
    final DateTime? pickedStartDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedStartDate != null) {
      final TimeOfDay? pickedStartTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
      );

      if (pickedStartTime != null) {
        // Select End Date
        final DateTime? pickedEndDate = await showDatePicker(
          context: Get.context!,
          initialDate: pickedStartDate,
          firstDate: pickedStartDate,
          lastDate: DateTime(2100),
        );

        if (pickedEndDate != null) {
          final TimeOfDay? pickedEndTime = await showTimePicker(
            context: Get.context!,
            initialTime: pickedStartTime,
          );

          if (pickedEndTime != null) {
            startDateTime = DateTime(
              pickedStartDate.year,
              pickedStartDate.month,
              pickedStartDate.day,
              pickedStartTime.hour,
              pickedStartTime.minute,
            );
            endDateTime = DateTime(
              pickedEndDate.year,
              pickedEndDate.month,
              pickedEndDate.day,
              pickedEndTime.hour,
              pickedEndTime.minute,
            );
            startTime = pickedStartTime;
            endTime = pickedEndTime;
            update();
          }
        }
      }
    }
  }

  Future<void> fetchVendorByDoc(String vendorType) async {
    try {
      isLoading.value = true;

      final snapshot =
          await FirebaseFirestore.instance.collection(vendorType).get();

      vendors.value = snapshot.docs.map((doc) {
        final data = doc.data();
        return Vendor.fromMap(data);
      }).toList();

      debugPrint('---------> Vendors :$vendors');
      debugPrint('---------> For Vendor Type :$vendorType');
    } catch (e) {
      debugPrint('Error fetching vendors: $e');
      vendors.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> sendImageToFirebase(File? imageFile) async {
    try {
      debugPrint('----------> Send Image To Firebase Started');

      if (imageFile == null) return null;

      // Create a reference to the location you want to upload to
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('vendor_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('-----> Send Image To Firebase Completed. URL: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  Future<String?> uploadImageToFirebase() async {
    if (selectedImage == null) return null;

    try {
      // Get file size and show to user
      final fileSize = await selectedImage!.length();
      final fileSizeMB = fileSize / (1024 * 1024);
      debugPrint('Uploading file of ${fileSizeMB.toStringAsFixed(2)} MB');

      // Warn user if file is too large
      if (fileSize > 10 * 1024 * 1024) {
        // 10MB
        Get.snackbar(
          'Warning',
          'Large file may take longer to upload',
          duration: Duration(seconds: 3),
        );
      }

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('vendor_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Show upload progress
      final UploadTask uploadTask = storageRef.putFile(selectedImage!);

      // Create a Completer to handle the upload
      final completer = Completer<String?>();
      final subscription = uploadTask.snapshotEvents.listen((snapshot) {
        final progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        debugPrint('Upload progress: ${progress.toStringAsFixed(1)}%');

        // Update UI with progress
        Get.dialog(
          AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Uploading: ${progress.toStringAsFixed(1)}%'),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      });

      // Handle completion
      uploadTask.then((snapshot) async {
        await subscription.cancel();
        final url = await snapshot.ref.getDownloadURL();
        completer.complete(url);
        Get.back(); // Close progress dialog
      }).catchError((error) {
        subscription.cancel();
        completer.completeError(error);
        Get.back(); // Close progress dialog
      });

      // Return with timeout
      return await completer.future.timeout(
        Duration(seconds: fileSize > 5 * 1024 * 1024 ? 120 : 60),
        onTimeout: () {
          uploadTask.cancel();
          throw 'Upload timed out. Please try again with better network';
        },
      );
    } catch (e) {
      debugPrint('Upload error: $e');
      rethrow;
    }
  }

  Future<String?> uploadWithRetry(File file, {int maxRetries = 3}) async {
    int attempt = 0;
    while (attempt < maxRetries) {
      try {
        return await uploadImageToFirebase()
            .timeout(Duration(seconds: 60 + (attempt * 30)));
      } catch (e) {
        attempt++;
        debugPrint('Attempt $attempt failed: $e');
        if (attempt == maxRetries) rethrow;
        await Future.delayed(Duration(seconds: 5 * attempt));
      }
    }
    return null;
  }

  Future<void> addVendor(
      String vendorType, Map<String, dynamic> vendorData) async {
    try {
      isAddingVendor.value = true;

      // Show loading
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Handle image upload
      if (selectedImage != null) {
        try {
          final url = await uploadImageToFirebase().timeout(
            Duration(seconds: 60),
            onTimeout: () => throw 'Upload timed out after 30 seconds',
          );
          vendorData['VendorImage'] = url;
        } catch (e) {
          uploadWithRetry(selectedImage!);
          Get.back(); // Close loading
          Get.snackbar(
            'Upload Error',
            e.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }

      // Add to Firestore
      await firestore
          .collection(vendorType)
          .add(vendorData)
          .timeout(Duration(seconds: 15));

      // Success
      Get.back(); // Close loading
      Get.snackbar(
        'Success',
        'Vendor added successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back(); // Navigate back
      resetForm();
    } on TimeoutException {
      Get.back();
      Get.snackbar(
        'Timeout',
        'Operation took too long',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isAddingVendor.value = false;
    }
  }

  void resetForm() {
    selectedImage = null;
    vendorLocation = null;
    update();
  }

  // $--------------------------------- Helper Functions --------------------------------->>>

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
