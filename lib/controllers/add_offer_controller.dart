import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/merchant_offers_service.dart';
import '../core/errors/app_exception.dart';

/// Controller for Add New Offer flow (4-step wizard)
/// Manages state, validation, and API calls for creating offers progressively
class AddOfferController extends GetxController {
  final _service = MerchantOffersService.instance;

  // ── Offer ID (set after Step 1, used for updates) ───────────────────────────
  String? offerId;

  // ── Current Step ────────────────────────────────────────────────────────────
  final currentStep = 0.obs;
  final completedSteps = <int>{}.obs;

  // ── Loading States ──────────────────────────────────────────────────────────
  final isLoading = false.obs;
  final isSavingStep = false.obs;

  // ── Error Handling ──────────────────────────────────────────────────────────
  final errorMessage = Rxn<String>();

  // ── Step 1: Basic Info ──────────────────────────────────────────────────────
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final termsController = TextEditingController();
  final selectedOfferType = 'in-store'.obs; // 'in-store' | 'online'
  final selectedCategories = <String>[].obs;
  final selectedStatus = 'draft'.obs; // Always start as draft
  final bannerFile = Rxn<File>();
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // ── Step 2: Scan Info ───────────────────────────────────────────────────────
  final selectedDiscountType = 'percentage'.obs; // 'percentage' | 'amount' | 'buy_x_get_y'
  final redemptionUrlController = TextEditingController();
  final couponCodeController = TextEditingController();
  final redemptionLimitController = TextEditingController();
  final qrCodeFile = Rxn<File>();
  final barCodeFile = Rxn<File>();

  // ── Step 3: Location Info ───────────────────────────────────────────────────
  final selectedLocationIds = <String>[].obs;
  final availableLocations = <Map<String, dynamic>>[].obs;
  final isLoadingLocations = false.obs;

  // ── Step 4: Target Audience ─────────────────────────────────────────────────
  final selectedDemographics = <String>[].obs;
  final selectedInterests = <String>[].obs;
  final selectedBehaviors = <String>[].obs;
  final selectedRadiusKm = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _loadMerchantLocations();
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    termsController.dispose();
    redemptionUrlController.dispose();
    couponCodeController.dispose();
    redemptionLimitController.dispose();
    super.onClose();
  }

  // ── Load Draft Data ─────────────────────────────────────────────────────────

  void loadDraftData(Map<String, dynamic> draft) {
    offerId = draft['_id'] ?? draft['id'];

    // Step 1: Basic Info
    titleController.text = draft['title'] ?? '';
    descriptionController.text = draft['description'] ?? '';
    termsController.text = draft['termsAndConditions'] ?? '';
    selectedOfferType.value = draft['offerType'] ?? 'in-store';

    if (draft['categories'] != null) {
      selectedCategories.value = List<String>.from(draft['categories']);
    }

    if (draft['status'] != null) {
      selectedStatus.value = draft['status'];
    }

    if (draft['startDate'] != null) {
      startDate.value = DateTime.parse(draft['startDate']);
    }

    if (draft['endDate'] != null) {
      endDate.value = DateTime.parse(draft['endDate']);
    }

    completedSteps.add(0);

    // Step 2: Scan Info
    if (draft['discountType'] != null) {
      selectedDiscountType.value = draft['discountType'];
      completedSteps.add(1);
    }

    if (draft['redemptionUrl'] != null) {
      redemptionUrlController.text = draft['redemptionUrl'];
    }

    if (draft['couponCode'] != null) {
      couponCodeController.text = draft['couponCode'];
    }

    if (draft['redemptionLimit'] != null) {
      redemptionLimitController.text = draft['redemptionLimit'].toString();
    }

    // Step 3: Location Info
    if (draft['locationIds'] != null && (draft['locationIds'] as List).isNotEmpty) {
      selectedLocationIds.value = List<String>.from(
        (draft['locationIds'] as List).map((e) => e is String ? e : e['_id']),
      );
      completedSteps.add(2);
    }

    // Step 4: Target Audience
    if (draft['targetAudience'] != null) {
      final audience = draft['targetAudience'] as Map<String, dynamic>;

      if (audience['demographics'] != null) {
        selectedDemographics.value = List<String>.from(audience['demographics']);
      }

      if (audience['interests'] != null) {
        selectedInterests.value = List<String>.from(audience['interests']);
      }

      if (audience['behaviors'] != null) {
        selectedBehaviors.value = List<String>.from(audience['behaviors']);
      }

      if (audience['radiusKm'] != null) {
        selectedRadiusKm.value = audience['radiusKm'] as int;
      }

      completedSteps.add(3);
    }

    // Determine which step to resume
    currentStep.value = _determineResumeStep(draft);
  }

  int _determineResumeStep(Map<String, dynamic> draft) {
    bool hasScanInfo = draft['discountType'] != null ||
        draft['couponCode'] != null ||
        draft['qrCodeUrl'] != null;

    bool hasLocationInfo =
        draft['locationIds'] != null && (draft['locationIds'] as List).isNotEmpty;

    bool hasTargetAudience = draft['targetAudience'] != null;

    if (!hasScanInfo) return 1;
    if (!hasLocationInfo) return 2;
    if (!hasTargetAudience) return 3;

    return 3; // All steps done
  }

  // ── Load Merchant Locations ─────────────────────────────────────────────────

  Future<void> _loadMerchantLocations() async {
    try {
      isLoadingLocations.value = true;
      final result = await _service.getMerchantLocations();

      result
          .onSuccess((locations) {
            availableLocations.value = locations;
          })
          .onFailure((error) {
            print('❌ Error loading locations: ${error.message}');
          });
    } finally {
      isLoadingLocations.value = false;
    }
  }

  // ── Validation ──────────────────────────────────────────────────────────────

  bool validateStep(int step) {
    errorMessage.value = null;

    switch (step) {
      case 0: // Basic Info
        if (titleController.text.trim().isEmpty) {
          errorMessage.value = 'Please enter offer title';
          return false;
        }
        if (descriptionController.text.trim().isEmpty) {
          errorMessage.value = 'Please enter offer description';
          return false;
        }
        if (termsController.text.trim().isEmpty) {
          errorMessage.value = 'Please enter terms and conditions';
          return false;
        }
        if (selectedOfferType.value == 'Select offer type or category...') {
          errorMessage.value = 'Please select offer type';
          return false;
        }
        if (startDate.value == null) {
          errorMessage.value = 'Please select start date';
          return false;
        }
        if (endDate.value == null) {
          errorMessage.value = 'Please select end date';
          return false;
        }
        if (endDate.value!.isBefore(startDate.value!)) {
          errorMessage.value = 'End date must be after start date';
          return false;
        }
        return true;

      case 1: // Scan Info (optional fields, always valid)
        return true;

      case 2: // Location Info
        if (selectedLocationIds.isEmpty) {
          errorMessage.value = 'Please select at least one location';
          return false;
        }
        return true;

      case 3: // Target Audience (optional fields, always valid)
        return true;

      default:
        return false;
    }
  }

  // ── Save Current Step ───────────────────────────────────────────────────────

  Future<bool> saveCurrentStep() async {
    if (!validateStep(currentStep.value)) {
      return false;
    }

    try {
      isSavingStep.value = true;
      errorMessage.value = null;

      switch (currentStep.value) {
        case 0:
          return await _saveBasicInfo();
        case 1:
          return await _saveScanInfo();
        case 2:
          return await _saveLocationInfo();
        case 3:
          return await _saveTargetAudience();
        default:
          return false;
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
      return false;
    } finally {
      isSavingStep.value = false;
    }
  }

  Future<bool> _saveBasicInfo() async {
    // If offerId exists, update the existing offer instead of creating new one
    if (offerId != null) {
      final result = await _service.editOffer(
        offerId: offerId!,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        offerType: selectedOfferType.value,
        startDate: '${startDate.value!.toUtc().toIso8601String()}',
        endDate: '${endDate.value!.toUtc().toIso8601String()}',
        termsAndConditions: termsController.text.trim(),
        categories: selectedCategories,
        status: 'draft',
        bannerFile: bannerFile.value,
        redemptionLimit: redemptionLimitController.text.isNotEmpty
            ? int.tryParse(redemptionLimitController.text)
            : null,
      );

      return result
          .onSuccess((_) {
            completedSteps.add(0);
          })
          .onFailure((error) {
            errorMessage.value = error.message;
          })
          .isSuccess;
    }

    // Create new offer only if offerId doesn't exist
    final result = await _service.createOffer(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      offerType: selectedOfferType.value,
      startDate: '${startDate.value!.toUtc().toIso8601String()}',
      endDate: '${endDate.value!.toUtc().toIso8601String()}',
      termsAndConditions: termsController.text.trim(),
      categories: selectedCategories,
      status: 'draft', // Always create as draft
      bannerFile: bannerFile.value,
      redemptionLimit: redemptionLimitController.text.isNotEmpty
          ? int.tryParse(redemptionLimitController.text)
          : null,
    );

    return result
        .onSuccess((data) {
          offerId = data['_id'] ?? data['id'];
          completedSteps.add(0);
        })
        .onFailure((error) {
          errorMessage.value = error.message;
        })
        .isSuccess;
  }

  Future<bool> _saveScanInfo() async {
    if (offerId == null) {
      errorMessage.value = 'Offer ID not found. Please restart.';
      return false;
    }

    final result = await _service.updateScanInfo(
      offerId: offerId!,
      discountType: selectedDiscountType.value,
      redemptionUrl: redemptionUrlController.text.trim().isNotEmpty
          ? redemptionUrlController.text.trim()
          : null,
      couponCode: couponCodeController.text.trim().isNotEmpty
          ? couponCodeController.text.trim()
          : null,
      redemptionLimit: redemptionLimitController.text.isNotEmpty
          ? int.tryParse(redemptionLimitController.text)
          : null,
      qrCodeFile: qrCodeFile.value,
      barCodeFile: barCodeFile.value,
    );

    return result
        .onSuccess((_) {
          completedSteps.add(1);
        })
        .onFailure((error) {
          errorMessage.value = error.message;
        })
        .isSuccess;
  }

  Future<bool> _saveLocationInfo() async {
    if (offerId == null) {
      errorMessage.value = 'Offer ID not found. Please restart.';
      return false;
    }

    final result = await _service.updateLocationInfo(
      offerId: offerId!,
      locationIds: selectedLocationIds,
      startDate: startDate.value?.toIso8601String(),
      endDate: endDate.value?.toIso8601String(),
    );

    return result
        .onSuccess((_) {
          completedSteps.add(2);
        })
        .onFailure((error) {
          errorMessage.value = error.message;
        })
        .isSuccess;
  }

  Future<bool> _saveTargetAudience() async {
    if (offerId == null) {
      errorMessage.value = 'Offer ID not found. Please restart.';
      return false;
    }

    final result = await _service.updateTargetAudience(
      offerId: offerId!,
      demographics: selectedDemographics.isNotEmpty ? selectedDemographics : null,
      interests: selectedInterests.isNotEmpty ? selectedInterests : null,
      behaviors: selectedBehaviors.isNotEmpty ? selectedBehaviors : null,
      radiusKm: selectedRadiusKm.value,
    );

    return result
        .onSuccess((_) {
          completedSteps.add(3);
        })
        .onFailure((error) {
          errorMessage.value = error.message;
        })
        .isSuccess;
  }

  // ── Activate Offer (Final Step) ─────────────────────────────────────────────

  Future<bool> activateOffer() async {
    if (offerId == null) {
      errorMessage.value = 'Offer ID not found. Please restart.';
      return false;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _service.editOffer(
        offerId: offerId!,
        status: 'active', // Change from draft to active
      );

      return result
          .onSuccess((_) {
            // Offer activated successfully
          })
          .onFailure((error) {
            errorMessage.value = error.message;
          })
          .isSuccess;
    } finally {
      isLoading.value = false;
    }
  }

  // ── Navigation ──────────────────────────────────────────────────────────────

  Future<void> goToNextStep() async {
    final success = await saveCurrentStep();
    if (success && currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    // Only allow going to completed steps or current step
    if (completedSteps.contains(step) || step == currentStep.value) {
      currentStep.value = step;
    }
  }

  // ── Reset ───────────────────────────────────────────────────────────────────

  void reset() {
    offerId = null;
    currentStep.value = 0;
    completedSteps.clear();
    titleController.clear();
    descriptionController.clear();
    termsController.clear();
    redemptionUrlController.clear();
    couponCodeController.clear();
    redemptionLimitController.clear();
    selectedOfferType.value = 'in-store';
    selectedCategories.clear();
    selectedStatus.value = 'draft';
    selectedDiscountType.value = 'percentage';
    selectedLocationIds.clear();
    selectedDemographics.clear();
    selectedInterests.clear();
    selectedBehaviors.clear();
    selectedRadiusKm.value = null;
    bannerFile.value = null;
    qrCodeFile.value = null;
    barCodeFile.value = null;
    startDate.value = null;
    endDate.value = null;
    errorMessage.value = null;
  }
}
