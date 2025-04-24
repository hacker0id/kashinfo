import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/modules/vendors/vendor_controller.dart';
import 'package:kashinfo/widgets/button.dart';
import 'package:kashinfo/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen({super.key});

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final VendorController vendorController = Get.put(VendorController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedServiceType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.orange, AppColors.pink],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Add New Vendor'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image Picker
                GestureDetector(
                  onTap: vendorController.pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white70,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: vendorController.selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              vendorController.selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            FontAwesomeIcons.camera,
                            size: 40,
                            color: AppColors.pink,
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Name Field
                CustomTextField(
                  controller: nameController,
                  hintText: 'Vendor Name',
                  icon: FontAwesomeIcons.user,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),

                // Phone Field
                CustomTextField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  icon: FontAwesomeIcons.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Phone is required' : null,
                ),
                const SizedBox(height: 16),

                // WhatsApp Field
                CustomTextField(
                  controller: whatsappController,
                  hintText: 'WhatsApp Number',
                  icon: FontAwesomeIcons.whatsapp,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'WhatsApp is required' : null,
                ),
                const SizedBox(height: 16),

                // Email Field
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  icon: FontAwesomeIcons.envelope,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Email is required' : null,
                ),
                const SizedBox(height: 16),

                // Service Type Field
                DropdownButtonFormField<String>(
                  value: selectedServiceType,
                  dropdownColor: Colors.white,
                  icon:
                      Icon(FontAwesomeIcons.chevronDown, color: AppColors.pink),
                  iconEnabledColor: AppColors.pink,
                  style: TextStyle(
                    color: AppColors.pink,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(FontAwesomeIcons.briefcase, color: AppColors.pink),
                    hintText: 'Service Type',
                    hintStyle: TextStyle(
                      color: AppColors.pink,
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.pink),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.pink),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.pink),
                    ),
                  ),
                  items: [
                    'Health',
                    'Grocery',
                    'Shopping',
                    'Travel',
                    'Services',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        selectionColor: AppColors.pink,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedServiceType = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Service type is required' : null,
                ),
                const SizedBox(height: 16),

                // Date and Time Picker
                Button(
                  showIcon: false,
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  onPressed: vendorController.selectDateTime,
                  text: vendorController.startDateTime != null &&
                          vendorController.endDateTime != null
                      ? '${vendorController.startDateTime!.day}/${vendorController.startDateTime!.month}/${vendorController.startDateTime!.year} ${vendorController.startTime!.hour}:${vendorController.startTime!.minute}\n${vendorController.endDateTime!.day}/${vendorController.endDateTime!.month}/${vendorController.endDateTime!.year} ${vendorController.endTime!.hour}:${vendorController.endTime!.minute}'
                      : 'Set Availability',
                ),
                const SizedBox(height: 16),

                // Location Picker
                Button(
                  showIcon: false,
                  width: MediaQuery.sizeOf(context).width * 0.6,
                  onPressed: vendorController.getLocation,
                  text: vendorController.vendorLocation != null
                      ? 'Location Set ✅'
                      : 'Set Location',
                ),
                const SizedBox(height: 30),

                // Submit Button
                Obx(() => Button(
                      width: MediaQuery.sizeOf(context).width * 0.8,
                      onPressed: vendorController.isAddingVendor.value
                          ? () {}
                          : () {
                              if (_formKey.currentState!.validate()) {
                                if (vendorController.startDateTime == null ||
                                    vendorController.endDateTime == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Please select availability time',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                if (vendorController.vendorLocation == null) {
                                  Get.snackbar(
                                    'Error',
                                    'Please set location',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                vendorController
                                    .addVendor(selectedServiceType!, {
                                  'VendorName': nameController.text,
                                  'VendorPhone': phoneController.text,
                                  'VendorServiceType': selectedServiceType,
                                  'VendorAddress':
                                      vendorController.vendorLocation,
                                  'VendorStartTime': Timestamp.fromDate(
                                      vendorController.startDateTime!),
                                  'VendorEndTime': Timestamp.fromDate(
                                      vendorController.endDateTime!),
                                  'VendorWhatsAppPhone':
                                      whatsappController.text,
                                  'VendorEmail': emailController.text,
                                  'VendorImage':
                                      vendorController.selectedImage?.path,
                                });
                              }
                            },
                      text: vendorController.isAddingVendor.value
                          ? 'Adding...'
                          : 'Add Vendor',
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
