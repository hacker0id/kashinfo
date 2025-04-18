import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  String vendorName;
  String vendorEmail;
  int vendorId;
  bool vendorIsPhoneWhatsApp;
  int vendorPhone;
  String vendorService;
  GeoPoint vendorAddress;
  Timestamp vendorTimings;
  int? vendorWhatsAppPhone;

  Vendor({
    required this.vendorName,
    required this.vendorEmail,
    required this.vendorId,
    required this.vendorIsPhoneWhatsApp,
    required this.vendorPhone,
    required this.vendorService,
    required this.vendorAddress,
    required this.vendorTimings,
    this.vendorWhatsAppPhone,
  });

  factory Vendor.fromMap(Map<String, dynamic> data) {
    final timingValue = data['VendorAvailabilityTimings'];
    return Vendor(
      vendorName: data['VendorName'] ?? '',
      vendorEmail: data['VendorEmail'] ?? '',
      vendorId: data['VendorId'] ?? 0,
      vendorIsPhoneWhatsApp: data['VendorPhoneIsWhatsAppPhone'] ?? false,
      vendorPhone: int.tryParse(data['VendorPhone'].toString()) ?? 0,
      vendorService: data['VendorServiceType'] ?? '',
      vendorAddress: GeoPoint(
        (data['VendorAddress']?['lat'] ?? 0.0).toDouble(),
        (data['VendorAddress']?['long'] ?? 0.0).toDouble(),
      ),
      vendorTimings: timingValue is Timestamp
          ? timingValue
          : Timestamp.fromDate(
              DateTime.tryParse(timingValue.toString()) ?? DateTime.now()),
      vendorWhatsAppPhone:
          int.tryParse(data['VendorWhatsAppPhone']?.toString() ?? ''),
    );
  }
}
