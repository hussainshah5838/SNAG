import 'dart:io';
import 'package:dio/dio.dart';
import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';

/// All merchant onboarding API calls.
/// Mirrors backend: modules/merchant/onboarding/
class MerchantOnboardingService {
  MerchantOnboardingService._();
  static final MerchantOnboardingService instance = MerchantOnboardingService._();

  final _client = ApiClient.instance;

  // ── Branch Profile (Create) ─────────────────────────────────────────────────

  /// Create branch profile during onboarding (POST)
  Future<Result<String>> saveBranchProfile({
    required String branchName,
    required String phoneNumber,
    required String branchAddress,
    required String industry,
    required List<String> subCategories,
    File? logoFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'branchName':    branchName,
        'phoneNumber':   phoneNumber,
        'branchAddress': branchAddress,
        'industry':      industry,
        for (int i = 0; i < subCategories.length; i++)
          'subCategories[$i]': subCategories[i],
        if (logoFile != null)
          'logo': await MultipartFile.fromFile(
            logoFile.path,
            filename: logoFile.path.split('/').last,
          ),
      });
      final res = await _client.postFormData(ApiEndpoints.merchantBranchProfile, formData);
      return Result.success(res.data['message'] as String? ?? 'Branch profile saved');
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Branch Profile (Edit) ───────────────────────────────────────────────────

  /// Edit branch profile in settings (PATCH)
  /// All fields are optional for partial updates
  Future<Result<String>> editBranchProfile({
    String? branchName,
    String? phoneNumber,
    String? branchAddress,
    String? industry,
    List<String>? subCategories,
    File? logoFile,
    String? role,
  }) async {
    try {
      final formData = FormData.fromMap({
        if (branchName != null) 'branchName': branchName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (branchAddress != null) 'branchAddress': branchAddress,
        if (industry != null) 'industry': industry,
        if (role != null) 'role': role,
        // Send array items separately with same key - this is how multipart/form-data handles arrays
        if (subCategories != null)
          ...{
            for (int i = 0; i < subCategories.length; i++)
              'subCategories[$i]': subCategories[i]
          },
        if (logoFile != null)
          'logo': await MultipartFile.fromFile(
            logoFile.path,
            filename: logoFile.path.split('/').last,
          ),
      });
      
      final res = await _client.patchFormData(ApiEndpoints.merchantBranchProfile, formData);
      return Result.success(res.data['message'] as String? ?? 'Branch profile updated');
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(ServerException(e.toString()));
    }
  }

  // ── Add Location ────────────────────────────────────────────────────────────

  Future<Result<String>> addLocation({
    required String address,
    required String state,
    required String country,
    required String branchAddress,
    required String locationType, // 'main' or 'franchise'
    required double lat,
    required double lng,
    File? bannerFile,
    String? phoneNumber,
    String? email,
  }) async {
    try {
      final formData = FormData.fromMap({
        'address':       address,
        'state':         state,
        'country':       country,
        'branchAddress': branchAddress,
        'locationType':  locationType,
        'coordinates':   {'lat': lat, 'lng': lng},
        'branchInfo': {
          if (phoneNumber != null && phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber,
          if (email != null && email.isNotEmpty) 'email': email,
        },
        if (bannerFile != null)
          'banner': await MultipartFile.fromFile(
            bannerFile.path,
            filename: bannerFile.path.split('/').last,
          ),
      });
      
      final res = await _client.postFormData(ApiEndpoints.merchantLocations, formData);
      return Result.success(res.data['message'] as String? ?? 'Location added');
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Branch Info ─────────────────────────────────────────────────────────────

  Future<Result<String>> saveBranchInfo({
    required String description,
    required String website,
    required List<String> socialMedia,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.merchantBranchInfo,
        data: {
          'description': description,
          'website': website,
          'socialMedia': socialMedia,
        },
      );
      return Result.success(res.data['message'] as String? ?? 'Branch info saved');
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Bulk Upload ─────────────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> bulkUploadLocations({
    File? csvFile,
    String? notes,
  }) async {
    if (csvFile == null) {
      // Skip bulk upload - return success without API call
      return Result.success({'message': 'Bulk upload skipped'});
    }
    
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          csvFile.path,
          filename: csvFile.path.split('/').last,
        ),
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });
      final res = await _client.postFormData(ApiEndpoints.merchantBulkLocations, formData);
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Get Locations ───────────────────────────────────────────────────────────

  Future<Result<List<Map<String, dynamic>>>> getLocations() async {
    try {
      final res = await _client.get(ApiEndpoints.merchantLocations);
      final list = (res.data['data'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();
      return Result.success(list);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Get Location By ID ──────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> getLocationById(String locationId) async {
    try {
      final res = await _client.get(ApiEndpoints.merchantLocationById(locationId));
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Edit Location ───────────────────────────────────────────────────────────

  Future<Result<String>> editLocation({
    required String locationId,
    String? address,
    String? state,
    String? country,
    String? branchAddress,
    String? locationType,
    double? lat,
    double? lng,
    File? bannerFile,
    String? phoneNumber,
    String? email,
  }) async {
    try {
      // If there's a banner file, use FormData
      if (bannerFile != null) {
        final formData = FormData.fromMap({
          if (address != null) 'address': address,
          if (state != null) 'state': state,
          if (country != null) 'country': country,
          if (branchAddress != null) 'branchAddress': branchAddress,
          if (locationType != null) 'locationType': locationType,
          if (lat != null && lng != null) 'coordinates': {'lat': lat, 'lng': lng},
          if (phoneNumber != null || email != null) 'branchInfo': {
            if (phoneNumber != null) 'phoneNumber': phoneNumber,
            if (email != null) 'email': email,
          },
          'banner': await MultipartFile.fromFile(
            bannerFile.path,
            filename: bannerFile.path.split('/').last,
          ),
        });

        final res = await _client.patchFormData(
          ApiEndpoints.merchantLocationById(locationId),
          formData,
        );
        return Result.success(res.data['message'] as String? ?? 'Location updated');
      } else {
        // No banner file, use regular JSON
        final data = <String, dynamic>{};
        if (address != null) data['address'] = address;
        if (state != null) data['state'] = state;
        if (country != null) data['country'] = country;
        if (branchAddress != null) data['branchAddress'] = branchAddress;
        if (locationType != null) data['locationType'] = locationType;
        if (lat != null && lng != null) {
          data['coordinates'] = {'lat': lat, 'lng': lng};
        }
        if (phoneNumber != null || email != null) {
          data['branchInfo'] = {};
          if (phoneNumber != null) data['branchInfo']['phoneNumber'] = phoneNumber;
          if (email != null) data['branchInfo']['email'] = email;
        }
        
        final res = await _client.patch(
          ApiEndpoints.merchantLocationById(locationId),
          data: data,
        );
        return Result.success(res.data['message'] as String? ?? 'Location updated');
      }
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(ServerException(e.toString()));
    }
  }

  // ── Delete Location ─────────────────────────────────────────────────────────

  Future<Result<String>> deleteLocation(String locationId) async {
    try {
      final res = await _client.delete(ApiEndpoints.merchantLocationById(locationId));
      return Result.success(res.data['message'] as String? ?? 'Location deleted');
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Get Branch Profile ──────────────────────────────────────────────────────

  Future<Result<Map<String, dynamic>>> getBranchProfile() async {
    try {
      final res = await _client.get(ApiEndpoints.merchantBranchProfile);
      return Result.success(res.data['data'] as Map<String, dynamic>);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Complete Onboarding ─────────────────────────────────────────────────────

  Future<Result<String>> completeOnboarding() async {
    try {
      final res = await _client.post(ApiEndpoints.merchantComplete);
      return Result.success(res.data['message'] as String? ?? "You're all set");
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  // ── Merchant GPS Location ───────────────────────────────────────────────────

  Future<Result<String>> saveMerchantLocation({
    required double lat,
    required double lng,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.merchantMyLocation,
        data: {'lat': lat, 'lng': lng},
      );
      return Result.success(res.data['data']['message'] as String);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}
