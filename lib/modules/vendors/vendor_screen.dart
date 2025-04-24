import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:kashinfo/constants/app_colors.dart';
import 'package:kashinfo/modules/vendors/vendor_controller.dart';
import 'package:kashinfo/widgets/button.dart';

class VendorScreen extends StatefulWidget {
  final String category;

  VendorScreen({super.key, required this.category});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final VendorController vendorController = Get.put(VendorController());
  int? expandedIndex; // To track which tile is expanded

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((context) {
      vendorController.fetchVendorByDoc(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          if (vendorController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vendorController.vendors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No vendors available"),
                  Button(
                    onPressed: () async {
                      String dateStr = "2024-04-10 15:30:00";
                      DateTime dateTime = DateTime.parse(dateStr);
                      Timestamp timestamp = Timestamp.fromDate(dateTime);

                      await vendorController.addVendor('doctors', {
                        'VendorName': 'Raakib Zargar',
                        'VendorPhone': '1234567890',
                        'VendorServiceType': 'Engineer',
                        'VendorAddress': {'lat': 12.34, 'long': 56.78},
                        'VendorAvailabilityTimings': timestamp,
                        'VendorWhatsAppPhone': '1234567890',
                        'VendorEmail': 'abc@email.com',
                      });

                      debugPrint('STORED');
                    },
                    text: 'Store',
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: vendorController.vendors.length,
                  itemBuilder: (context, index) {
                    var vendor = vendorController.vendors[index];
                    bool isExpanded = expandedIndex == index;

                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: isExpanded ? 150 : 70,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                insetPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            vendor.vendorName,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            vendor.vendorService,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 20),
                                          Text("Phone: ${vendor.vendorPhone}"),
                                          Text("Email: ${vendor.vendorEmail}"),
                                          SizedBox(height: 20),
                                          // Text(
                                          //     "Availability: ${vendor.vendorAvailability}"),
                                          // Add other vendor fields if needed
                                          if (vendor.vendorImage != null)
                                            CachedNetworkImage(
                                              imageUrl: vendorController.vImage,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              vendorController.makePhoneCall(
                                                  vendor.vendorPhone
                                                      .toString());
                                            },
                                            icon: Icon(CupertinoIcons.phone),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              vendorController.makeSMS(vendor
                                                  .vendorPhone
                                                  .toString());
                                            },
                                            icon: Icon(
                                                CupertinoIcons.text_bubble),
                                          ),
                                          if (!vendor.vendorIsPhoneWhatsApp)
                                            IconButton(
                                              onPressed: () {
                                                vendorController.openWhatsApp(
                                                    vendor.vendorWhatsAppPhone!
                                                        .toString(),
                                                    message:
                                                        'Hello ${vendor.vendorName}');
                                              },
                                              icon: Icon(
                                                  FontAwesomeIcons.whatsapp),
                                            ),
                                          IconButton(
                                            onPressed: () {
                                              // Info dialog inside the main dialog
                                              // showCupertinoDialog(
                                              //   context: context,
                                              //   barrierDismissible: true,
                                              //   builder: (_) => Dialog(
                                              //     child: Container(
                                              //       height: 100,
                                              //       child: Center(
                                              //           child: Text(
                                              //               'Vendor Info Goes Here')),
                                              //     ),
                                              //   ),
                                              // );
                                            },
                                            icon: Icon(
                                                CupertinoIcons.info_circle),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              if (!isExpanded)
                                Expanded(
                                  child: ListTile(
                                    title: Text(vendor.vendorName),
                                    subtitle: Text(vendor.vendorService),
                                  ),
                                ),
                              AnimatedOpacity(
                                opacity: isExpanded ? 1 : 0,
                                duration: Duration(milliseconds: 300),
                                child: isExpanded
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(vendor.vendorName),
                                              Text(vendor.vendorService),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                        CupertinoIcons.phone),
                                                  ),
                                                  //SizedBox(width: 8),
                                                  IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(CupertinoIcons
                                                        .text_bubble),
                                                  ),

                                                  IconButton(
                                                    onPressed: () {
                                                      showCupertinoDialog(
                                                          barrierDismissible:
                                                              true,
                                                          context: context,
                                                          builder:
                                                              (_) => Dialog(
                                                                    child: Container(
                                                                        height:
                                                                            100,
                                                                        child: Center(
                                                                            child:
                                                                                Text('Vendor Info Goes Here'))),
                                                                  ));
                                                    },
                                                    icon: Icon(CupertinoIcons
                                                        .info_circle),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Button(
                  onPressed: () async {
                    String dateStr = "2024-04-10 15:30:00";
                    DateTime dateTime = DateTime.parse(dateStr);
                    Timestamp timestamp = Timestamp.fromDate(dateTime);

                    await vendorController.addVendor('scientists', {
                      'VendorName': 'Rafiya Zargar',
                      'VendorPhone': '1234567890',
                      'VendorServiceType': 'Engineer',
                      'VendorAddress': {'lat': 12.34, 'long': 56.78},
                      'VendorAvailabilityTimings': timestamp,
                      'VendorWhatsAppPhone': '1234567890',
                      'VendorEmail': 'abc@email.com',
                    });

                    debugPrint('STORED');
                  },
                  text: 'Store',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
