import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/merchant_offers_service.dart';

/// Edit offer controller - manages editing existing offers
class EditOfferController extends GetxController {
  final _service = MerchantOffersService.instance;

  // Offer ID
  String? offerId;

  // Loading states
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Basic Info
  final title = ''.obs;
  final description = ''.obs;
  final offerType = 'in-store'.obs;
  final categories = <String>[].obs;
  final status = 'active'.obs;
  final termsAndConditions = ''.obs;
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final bannerFile = Rxn<File>();
  final bannerUrl = Rxn<String>();

  // Scan Info
  final discountType = Rxn<String>();
  final redemptionUrl = Rxn<String>();
  final couponCode = Rxn<String>();
  final redemptionLimit = Rxn<int>();
  final qrCodeFile = Rxn<File>();
  final barCodeFile = Rxn<File>();
  final qrCodeUrl = Rxn<String>();
  final barCodeUrl = Rxn<String>();

  // Location Info
  final locationIds = <String>[].obs;
  final availableLocations = <Map<String, dynamic>>[].obs;

  // Error handling
  final error = Rxn<String>();

  /// Load offer data by ID
  Future<void> loadOffer(String id) async {
    try {
      isLoading.value = true;
      error.value = null;
      offerId = id;

      final result = await _service.getOfferById(id);

      result
          .onSuccess((data) {
            // Basic Info
            title.value = data['title'] as String? ?? '';
            description.value = data['description'] as String? ?? '';
            offerType.value = data['offerType'] as String? ?? 'in-store';
            status.value = data['status'] as String? ?? 'active';
            termsAndConditions.value = data['termsAndConditions'] as String? ?? '';
            bannerUrl.value = data['bannerUrl'] as String?;

            // Categories
            final cats = data['categories'] as List<dynamic>?;
            if (cats != null) {
              categories.value = cats.map((e) => e.toString()).toList();
            }

            // Dates
            final startDateStr = data['startDate'] as String?;
            final endDateStr = data['endDate'] as String?;
            if (startDateStr != null) {
              startDate.value = DateTime.parse(startDateStr);
            }
            if (endDateStr != null) {
              endDate.value = DateTime.parse(endDateStr);
            }

            // Scan Info
            discountType.value = data['discountType'] as String?;
            redemptionUrl.value = data['redemptionUrl'] as String?;
            couponCode.value = data['couponCode'] as String?;
            redemptionLimit.value = data['redemptionLimit'] as int?;
            qrCodeUrl.value = data['qrCodeUrl'] as String?;
            barCodeUrl.value = data['barCodeUrl'] as String?;

            // Location Info
            final locations = data['locationIds'] as List<dynamic>?;
            if (locations != null) {
              locationIds.value = locations
                  .map((e) => (e as Map<String, dynamic>)['_id'] as String)
                  .toList();
            }
          })
          .onFailure((err) {
            error.value = err.message;
          });
    } finally {
      isLoading.value = false;
    }
  }

  /// Load available locations
  Future<void> loadLocations() async {
    final result = await _service.getMerchantLocations();
    result.onSuccess((data) {
      availableLocations.value = data;
    });
  }

  /// Validate if offer is ready to publish - ALL fields required
  String? validateForPublish() {
    final missing = <String>[];

    // Basic Info - ALL REQUIRED
    if (title.value.isEmpty) missing.add('Title');
    if (description.value.isEmpty) missing.add('Description');
    if (termsAndConditions.value.isEmpty) missing.add('Terms & Conditions');
    if (bannerFile.value == null && bannerUrl.value == null) missing.add('Banner/Image');
    if (categories.isEmpty) missing.add('At least one Category');
    
    // Dates - REQUIRED
    if (startDate.value == null) missing.add('Start Date');
    if (endDate.value == null) missing.add('End Date');
    
    // Scan Info - ALL REQUIRED
    if (discountType.value == null || discountType.value!.isEmpty) missing.add('Discount Type');
    if (redemptionLimit.value == null) missing.add('Redemption Limit');
    
    // Must have BOTH QR code AND barcode
    final hasQR = qrCodeFile.value != null || qrCodeUrl.value != null;
    final hasBarcode = barCodeFile.value != null || barCodeUrl.value != null;
    if (!hasQR) missing.add('QR Code');
    if (!hasBarcode) missing.add('Barcode');
    
    // Must have BOTH coupon code AND redemption URL
    final hasCoupon = couponCode.value != null && couponCode.value!.isNotEmpty;
    final hasUrl = redemptionUrl.value != null && redemptionUrl.value!.isNotEmpty;
    if (!hasCoupon) missing.add('Coupon Code');
    if (!hasUrl) missing.add('Redemption URL');
    
    // Location Info - REQUIRED
    if (locationIds.isEmpty) missing.add('At least one Location');

    if (missing.isEmpty) return null;
    return 'Cannot publish. Missing required fields:\n• ${missing.join('\n• ')}';
  }

  /// Save offer with optional publish
  Future<bool> saveOffer({bool publishNow = false}) async {
    if (offerId == null) return false;

    // Validate if publishing
    if (publishNow) {
      final validationError = validateForPublish();
      if (validationError != null) {
        Get.dialog(
          AlertDialog(
            title: Text('Cannot Publish Offer'),
            content: Text(validationError),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return false;
      }
    }

    try {
      isSaving.value = true;
      error.value = null;

      final result = await _service.editOffer(
        offerId: offerId!,
        title: title.value,
        description: description.value,
        offerType: offerType.value,
        status: publishNow ? 'active' : status.value, // Change to active if publishing
        categories: categories.toList(),
        termsAndConditions: termsAndConditions.value,
        startDate: startDate.value?.toUtc().toIso8601String(),
        endDate: endDate.value?.toUtc().toIso8601String(),
        redemptionLimit: redemptionLimit.value,
        locationIds: locationIds.toList(),
        bannerFile: bannerFile.value,
        qrCodeFile: qrCodeFile.value,
        barCodeFile: barCodeFile.value,
        discountType: discountType.value,
        redemptionUrl: redemptionUrl.value,
        couponCode: couponCode.value,
      );

      bool success = false;
      result
          .onSuccess((data) {
            success = true;
            Get.snackbar(
              'Success',
              publishNow ? 'Offer published successfully' : 'Offer saved as draft',
            );
          })
          .onFailure((err) {
            error.value = err.message;
            Get.snackbar('Error', err.message);
          });

      return success;
    } finally {
      isSaving.value = false;
    }
  }

  /// Delete offer
  Future<bool> deleteOffer() async {
    if (offerId == null) return false;

    try {
      final result = await _service.deleteOffer(offerId!);

      bool success = false;
      result
          .onSuccess((message) {
            success = true;
            Get.snackbar('Success', 'Offer deleted successfully');
          })
          .onFailure((err) {
            Get.snackbar('Error', err.message);
          });

      return success;
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    // Clean up
    super.onClose();
  }
}
