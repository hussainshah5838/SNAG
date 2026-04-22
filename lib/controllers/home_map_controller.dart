import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/offer_model.dart';
import '../services/client_offers_service.dart';

class HomeMapController extends GetxController {
  static HomeMapController get instance => Get.find<HomeMapController>();

  final _service = ClientOffersService.instance;

  final isLoading = false.obs;
  final offers = <OfferModel>[].obs;
  final selectedCategoryIndex = 0.obs; // 0 = All
  final userPosition = Rxn<LatLng>();
  final markers = Rx<Set<Marker>>({});

  static const defaultPosition = LatLng(24.9414037, 67.0228639); // Karachi

  // Must match the labels list in user_home.dart (index 0 = All = null)
  static const _categoryValues = <String?>[
    null,
    'Food & Drinks',
    'Health',
    'Shopping',
    'Services',
    'Beauty',
  ];

  GoogleMapController? _mapCtrl;

  @override
  void onInit() {
    super.onInit();
    _initLocation();
  }

  @override
  void onClose() {
    _mapCtrl?.dispose();
    super.onClose();
  }

  // ── Location ────────────────────────────────────────────────────────────────

  Future<void> _initLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        userPosition.value = defaultPosition;
      } else {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        userPosition.value = LatLng(pos.latitude, pos.longitude);
      }
    } catch (_) {
      userPosition.value = defaultPosition;
    }

    await fetchOffers();
  }

  void onMapCreated(GoogleMapController controller) {
    _mapCtrl = controller;
    if (userPosition.value != null) {
      _mapCtrl!.animateCamera(
        CameraUpdate.newLatLngZoom(userPosition.value!, 13),
      );
    }
  }

  // ── Offers ──────────────────────────────────────────────────────────────────

  Future<void> fetchOffers() async {
    isLoading.value = true;

    final result = await _service.discoverOffers(
      lat: userPosition.value?.latitude,
      lng: userPosition.value?.longitude,
      radiusKm: 10,
      category: _categoryValues[selectedCategoryIndex.value],
    );

    result
        .onSuccess((data) {
          offers.value = data;
          _buildMarkers();
        })
        .onFailure((e) {
          // Error loading offers
        });

    isLoading.value = false;
  }

  // ── Markers ─────────────────────────────────────────────────────────────────

  void _buildMarkers() {
    final newMarkers = <Marker>{};
    final seenLocIds = <String>{};

    // Group by merchant so the InfoWindow shows correct offer count
    final groups = offersByMerchant;

    for (final entry in groups.entries) {
      final merchantName = entry.key;
      final merchantOffers = entry.value;
      final offerCount = merchantOffers.length;

      for (final offer in merchantOffers) {
        for (final loc in offer.locations) {
          if (!loc.isValid) continue;
          if (!seenLocIds.add(loc.id)) continue; // skip duplicate branches

          newMarkers.add(
            Marker(
              markerId: MarkerId(loc.id),
              position: LatLng(loc.lat, loc.lng),
              infoWindow: InfoWindow(
                title: merchantName,
                snippet:
                    '$offerCount offer${offerCount == 1 ? '' : 's'}'
                    '${loc.address != null ? ' · ${loc.address}' : ''}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure,
              ),
            ),
          );
        }
      }
    }

    markers.value = newMarkers;
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  void selectCategory(int index) {
    if (selectedCategoryIndex.value == index) return;
    selectedCategoryIndex.value = index;
    fetchOffers();
  }

  void recenter() {
    if (_mapCtrl == null || userPosition.value == null) return;
    _mapCtrl!.animateCamera(
      CameraUpdate.newLatLngZoom(userPosition.value!, 13),
    );
  }

  // ── Computed ─────────────────────────────────────────────────────────────────

  /// Offers grouped by merchant brand name — used by the bottom sheet
  Map<String, List<OfferModel>> get offersByMerchant {
    final groups = <String, List<OfferModel>>{};
    for (final offer in offers) {
      final key = offer.merchantBrand ?? offer.merchant;
      groups.putIfAbsent(key, () => []).add(offer);
    }
    return groups;
  }
}
