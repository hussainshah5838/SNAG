import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../core/utils/result.dart';
import '../models/shipping_address_model.dart';

/// Shipping address API calls
/// Handles all CRUD operations for client shipping addresses
class ShippingAddressService {
  ShippingAddressService._();
  static final ShippingAddressService instance = ShippingAddressService._();

  final _client = ApiClient.instance;

  /// Get all shipping addresses for current user
  Future<Result<List<ShippingAddressModel>>> getAddresses() async {
    try {
      final res = await _client.get(ApiEndpoints.shippingAddresses);
      final data = res.data['data'] as Map<String, dynamic>;
      final addresses = (data['addresses'] as List)
          .map((e) => ShippingAddressModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(addresses);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  /// Get single shipping address by ID
  Future<Result<ShippingAddressModel>> getAddressById(String id) async {
    try {
      final res = await _client.get(ApiEndpoints.shippingAddressById(id));
      final data = res.data['data'] as Map<String, dynamic>;
      final address = ShippingAddressModel.fromJson(data);
      return Result.success(address);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  /// Create new shipping address
  Future<Result<ShippingAddressModel>> createAddress({
    required String fullName,
    required String phoneNumber,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String zipCode,
    required String country,
  }) async {
    try {
      final res = await _client.post(
        ApiEndpoints.shippingAddresses,
        data: {
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'addressLine1': addressLine1,
          if (addressLine2 != null) 'addressLine2': addressLine2,
          'city': city,
          'state': state,
          'zipCode': zipCode,
          'country': country,
        },
      );
      final data = res.data['data'] as Map<String, dynamic>;
      final address = ShippingAddressModel.fromJson(data);
      return Result.success(address);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  /// Update existing shipping address
  Future<Result<ShippingAddressModel>> updateAddress({
    required String id,
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  }) async {
    try {
      final res = await _client.patch(
        ApiEndpoints.shippingAddressById(id),
        data: {
          if (fullName != null) 'fullName': fullName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          if (addressLine1 != null) 'addressLine1': addressLine1,
          if (addressLine2 != null) 'addressLine2': addressLine2,
          if (city != null) 'city': city,
          if (state != null) 'state': state,
          if (zipCode != null) 'zipCode': zipCode,
          if (country != null) 'country': country,
        },
      );
      final data = res.data['data'] as Map<String, dynamic>;
      final address = ShippingAddressModel.fromJson(data);
      return Result.success(address);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  /// Delete shipping address
  Future<Result<String>> deleteAddress(String id) async {
    try {
      final res = await _client.delete(ApiEndpoints.shippingAddressById(id));
      final message = res.data['message'] as String;
      return Result.success(message);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }

  /// Set address as default
  Future<Result<ShippingAddressModel>> setDefaultAddress(String id) async {
    try {
      final res = await _client.patch(ApiEndpoints.setDefaultAddress(id));
      final data = res.data['data'] as Map<String, dynamic>;
      final address = ShippingAddressModel.fromJson(data);
      return Result.success(address);
    } on AppException catch (e) {
      return Result.failure(e);
    }
  }
}
