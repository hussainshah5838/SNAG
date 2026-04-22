import 'package:flutter/material.dart';
import 'dart:math';
// Google Maps imports
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sheet/sheet.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:snag/config/env.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/discover_offers_controller.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/screens/user/user_home/user_search.dart';
import 'package:snag/view/screens/user/user_my_offers/u_offer_details.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  DiscoverOffersController? _controller;
  IndustryController? _industryController;
  
  GoogleMapController? _mapController;
  LatLng? _initialPosition;
  Set<Marker> _markers = {};
  bool _isLoadingLocation = true;
  bool _mapLoadFailed = false;
  bool _hasLocationPermission = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        // Check if controller already exists
        if (Get.isRegistered<DiscoverOffersController>()) {
          _controller = DiscoverOffersController.instance;
          _controller!.refresh(); // Reload offers
        } else {
          _controller = Get.put(DiscoverOffersController());
          // Manually call load since onInit might not trigger
          _controller!.loadOffersWithoutLocation();
        }
        
        _industryController = IndustryController.instance;
        
        // Initialize map position
        _initializeMapPosition();
        
        setState(() {});
      } catch (e) {
        // Error initializing controllers
      }
    });
  }

  Future<void> _initializeMapPosition() async {
    // Try to get user location first
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }
        
        if (permission == LocationPermission.whileInUse || 
            permission == LocationPermission.always) {
          Position position = await Geolocator.getCurrentPosition(
            locationSettings: LocationSettings(
              accuracy: LocationAccuracy.high,
            ),
          );
          
          setState(() {
            _initialPosition = LatLng(position.latitude, position.longitude);
            _isLoadingLocation = false;
          });
          return;
        }
      }
    } catch (e) {
      // Could not get user location
    }
    
    // Fallback: Calculate center from offers
    if (_controller != null && _controller!.offers.isNotEmpty) {
      double totalLat = 0;
      double totalLng = 0;
      int locationCount = 0;
      
      for (var offer in _controller!.offers) {
        for (var location in offer.locations) {
          if (location.isValid) {
            totalLat += location.lat;
            totalLng += location.lng;
            locationCount++;
          }
        }
      }
      
      if (locationCount > 0) {
        setState(() {
          _initialPosition = LatLng(totalLat / locationCount, totalLng / locationCount);
          _isLoadingLocation = false;
        });
        return;
      }
    }
    
    // Final fallback: Default location (you can change this to your city)
    setState(() {
      _initialPosition = LatLng(37.7749, -122.4194); // San Francisco
      _isLoadingLocation = false;
    });
  }

  void _buildMarkers() {
    if (_controller == null || _controller!.offers.isEmpty) return;
    
    final newMarkers = <Marker>{};
    final grouped = _controller!.offersByMerchant;
    
    grouped.forEach((merchantId, offers) {
      final firstOffer = offers.first;
      
      // Use first valid location from offer
      for (var location in firstOffer.locations) {
        if (location.isValid) {
          newMarkers.add(
            Marker(
              markerId: MarkerId(merchantId),
              position: LatLng(location.lat, location.lng),
              infoWindow: InfoWindow(
                title: firstOffer.merchantBrand ?? 'Merchant',
                snippet: '${offers.length} Offer${offers.length > 1 ? 's' : ''}',
              ),
              onTap: () {
                Get.bottomSheet(
                  _ViewSponsorDetails(
                    title: firstOffer.merchantBrand ?? 'Merchant',
                    image: firstOffer.merchantLogo ?? Assets.imagesKfc,
                    offers: offers,
                  ),
                  isScrollControlled: true,
                );
              },
            ),
          );
          break; // Only use first location for marker
        }
      }
    });
    
    setState(() {
      _markers = newMarkers;
    });
  }

  void _searchAndMoveToLocation(String query) {
    if (query.isEmpty || _controller == null || _mapController == null) return;
    
    final lowerQuery = query.toLowerCase();
    final grouped = _controller!.offersByMerchant;
    
    LatLng? closestLocation;
    double closestDistance = double.infinity;
    
    // Search through all offers and their locations
    for (var entry in grouped.entries) {
      final offers = entry.value;
      
      for (var offer in offers) {
        for (var location in offer.locations) {
          if (!location.isValid) continue;
          
          // Check if address matches
          final address = location.address?.toLowerCase() ?? '';
          if (address.contains(lowerQuery)) {
            // Found matching address
            if (_initialPosition != null) {
              final distance = _calculateDistance(
                _initialPosition!.latitude,
                _initialPosition!.longitude,
                location.lat,
                location.lng,
              );
              
              if (distance < closestDistance) {
                closestDistance = distance;
                closestLocation = LatLng(location.lat, location.lng);
              }
            } else {
              // No user location, just use first match
              closestLocation = LatLng(location.lat, location.lng);
              break;
            }
          }
        }
      }
    }
    
    // If no address match, try merchant name
    if (closestLocation == null) {
      for (var entry in grouped.entries) {
        final offers = entry.value;
        final merchantName = offers.first.merchantBrand?.toLowerCase() ?? '';
        
        if (merchantName.contains(lowerQuery)) {
          for (var offer in offers) {
            for (var location in offer.locations) {
              if (location.isValid) {
                if (_initialPosition != null) {
                  final distance = _calculateDistance(
                    _initialPosition!.latitude,
                    _initialPosition!.longitude,
                    location.lat,
                    location.lng,
                  );
                  
                  if (distance < closestDistance) {
                    closestDistance = distance;
                    closestLocation = LatLng(location.lat, location.lng);
                  }
                } else {
                  closestLocation = LatLng(location.lat, location.lng);
                  break;
                }
              }
            }
          }
        }
      }
    }
    
    // Move to closest location if found
    if (closestLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: closestLocation,
            zoom: 15.0,
          ),
        ),
      );
    }
  }
  
  // Calculate distance between two coordinates (in kilometers)
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Temporary static markers until Google Maps is configured
  List<Widget> _buildStaticMarkers() {
    if (_controller!.isLoading.value || _controller!.offers.isEmpty) {
      return [];
    }

    final markers = <Widget>[];
    final grouped = _controller!.offersByMerchant;
    
    int index = 0;
    final positions = [
      {'top': 175.0, 'right': 50.0},
      {'top': 240.0, 'left': 20.0},
      {'top': 260.0, 'right': 10.0},
      {'top': 320.0, 'left': 10.0},
      {'top': 400.0, 'left': 30.0},
      {'top': 360.0, 'right': 10.0},
      {'top': 440.0, 'right': 30.0},
      {'top': 480.0, 'left': 20.0},
    ];

    grouped.forEach((merchantId, offers) {
      if (index >= positions.length) return;
      
      final position = positions[index];
      final firstOffer = offers.first;
      final offerCount = offers.length;
      
      markers.add(
        Positioned(
          top: position['top'],
          left: position['left'],
          right: position['right'],
          child: GestureDetector(
            onTap: () {
              Get.bottomSheet(
                _ViewSponsorDetails(
                  title: firstOffer.merchantBrand ?? 'Merchant',
                  image: firstOffer.merchantLogo ?? Assets.imagesKfc,
                  offers: offers,
                ),
                isScrollControlled: true,
              );
            },
            child: Container(
              height: 44,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: kBorderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: kTertiaryColor.withValues(alpha: .16),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonImageView(
                    height: 24,
                    width: 24,
                    radius: 100,
                    fit: BoxFit.cover,
                    url: firstOffer.merchantLogo ?? Assets.imagesKfc,
                  ),
                  SizedBox(width: 6),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: firstOffer.merchantBrand ?? 'Merchant',
                          size: 12,
                          weight: FontWeight.w600,
                          paddingBottom: 2,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                        MyText(
                          text: '$offerCount Offer${offerCount > 1 ? 's' : ''}',
                          size: 10,
                          color: kQuaternaryColor,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ),
      );
      index++;
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _industryController == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Obx(() {
        // Rebuild markers when offers change
        if (!_controller!.isLoading.value && _markers.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _buildMarkers());
        }
        
        return Stack(
          children: [
            // Google Map
            _isLoadingLocation || _initialPosition == null
                ? Center(child: CircularProgressIndicator())
                : _mapLoadFailed
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined, size: 64, color: kQuaternaryColor),
                            SizedBox(height: 16),
                            MyText(
                              text: 'Map failed to load',
                              size: 16,
                              weight: FontWeight.w600,
                            ),
                            SizedBox(height: 8),
                            MyText(
                              text: 'Please check your API key configuration',
                              size: 14,
                              color: kQuaternaryColor,
                            ),
                            SizedBox(height: 16),
                            MyButton(
                              buttonText: 'Retry',
                              onTap: () {
                                setState(() {
                                  _mapLoadFailed = false;
                                  _isLoadingLocation = true;
                                });
                                _initializeMapPosition();
                              },
                            ),
                          ],
                        ),
                      )
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _initialPosition!,
                          zoom: 12.0,
                        ),
                        markers: _markers,
                        myLocationEnabled: false, // Disable blue dot
                        myLocationButtonEnabled: false, // Disable location button
                        zoomControlsEnabled: false,
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                      ),
            
            Center(child: Image.asset(Assets.imagesCurrentLoc, height: 90)),
            
            Positioned(
              right: 20,
              bottom: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(Assets.imagesRecenterIcon, height: 32),
                  Image.asset(Assets.imagesDirections, height: 32),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 55, 20, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Expanded(
                  child: MyTextField(
                    controller: _searchController,
                    marginBottom: 0,
                    hintText: 'Search merchant or location',
                    onChanged: (value) {
                      // Search as user types (after 2+ characters)
                      if (value.length >= 2) {
                        _searchAndMoveToLocation(value);
                      }
                    },
                    prefix: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.imagesSearchIcon, height: 22),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => UserSearch());
                  },
                  child: Image.asset(Assets.imagesMenu, height: 48),
                ),
              ],
            ),
          ),
          
          // Category Tabs - REMOVED
          // if (_industryController!.industries.isNotEmpty)
          //   Container(
          //     margin: EdgeInsets.only(top: 120),
          //     height: 35,
          //     child: ListView(...),
          //   ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Sheet(
                maxExtent: Get.height * 0.8,
                initialExtent: 150,
                minExtent: 50,
                physics: BouncingSheetPhysics(),
                child: _Sponsored(controller: _controller!),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : kLightBlueColor2,
          border: Border.all(color: kBlueBorderColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: MyText(
            text: label,
            size: 13,
            weight: FontWeight.w500,
            color: isSelected ? kPrimaryColor : kSecondaryColor,
          ),
        ),
      ),
    );
  }
}


class _Sponsored extends StatefulWidget {
  final DiscoverOffersController controller;
  
  const _Sponsored({Key? key, required this.controller}) : super(key: key);

  @override
  State<_Sponsored> createState() => _SponsoredState();
}

class _SponsoredState extends State<_Sponsored> {
  final Map<int, PageController> _pageControllers = {};

  @override
  void dispose() {
    _pageControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  PageController _getController(int index) {
    return _pageControllers.putIfAbsent(index, () => PageController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      width: Get.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withValues(alpha: .16),
            blurRadius: 16,
            offset: Offset(0, -8),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: 'Sponsored',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 16,
          ),
          Expanded(
            child: Obx(() {
              if (widget.controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final grouped = widget.controller.offersByMerchant;
              
              if (grouped.isEmpty) {
                return Center(
                  child: MyText(
                    text: 'No sponsored merchants available',
                    size: 14,
                    color: kQuaternaryColor,
                  ),
                );
              }

              final merchants = grouped.entries.toList();

              return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 20),
                shrinkWrap: true,
                itemCount: merchants.length,
                padding: AppSizes.ZERO,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final merchantId = merchants[index].key;
                  final offers = merchants[index].value;
                  final firstOffer = offers.first;
                  final merchantName = firstOffer.merchantBrand ?? 'Merchant';
                  final merchantLogo = firstOffer.merchantLogo;
                  
                  // Get all unique locations from offers
                  final locations = <String, Map<String, dynamic>>{};
                  for (var offer in offers) {
                    for (var location in offer.locations) {
                      if (!locations.containsKey(location.id)) {
                        locations[location.id] = {
                          'id': location.id,
                          'address': location.address ?? '',
                          'lat': location.lat,
                          'lng': location.lng,
                        };
                      }
                    }
                  }
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _headingRow(
                        title: merchantName,
                        onMore: () {
                          Get.bottomSheet(
                            _ViewMerchantLocations(
                              merchantName: merchantName,
                              merchantLogo: merchantLogo,
                              locations: locations.values.toList(),
                            ),
                            isScrollControlled: true,
                          );
                        },
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        height: 140,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              PageView.builder(
                                itemCount: offers.length,
                                physics: BouncingScrollPhysics(),
                                controller: _getController(index),
                                itemBuilder: (context, pageIndex) {
                                  final offer = offers[pageIndex];
                                  
                                  return merchantLogo != null
                                      ? CommonImageView(
                                          url: merchantLogo,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Image.asset(
                                          Assets.imagesKfcBanner,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        );
                                },
                              ),
                              if (offers.length > 1)
                                Positioned(
                                  bottom: 8,
                                  child: SmoothPageIndicator(
                                    controller: _getController(index),
                                    count: offers.length,
                                    effect: WormEffect(
                                      dotHeight: 8,
                                      dotWidth: 8,
                                      activeDotColor: kSecondaryColor,
                                      dotColor: kLightBlueColor2,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Row _headingRow({String? title, VoidCallback? onMore}) {
    return Row(
      children: [
        Expanded(
          child: MyText(text: title ?? '', size: 20, weight: FontWeight.w600),
        ),
        MyText(
          onTap: onMore,
          text: 'View More',
          size: 14,
          paddingRight: 6,
          weight: FontWeight.w600,
          color: kSecondaryColor,
        ),
        Image.asset(Assets.imagesArrowNext, height: 20, color: kSecondaryColor),
      ],
    );
  }
}

class _ViewMerchantLocations extends StatelessWidget {
  final String merchantName;
  final String? merchantLogo;
  final List<Map<String, dynamic>> locations;

  const _ViewMerchantLocations({
    super.key,
    required this.merchantName,
    this.merchantLogo,
    required this.locations,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 55),
      height: Get.height * 0.9,
      width: Get.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (merchantLogo != null)
                CommonImageView(
                  height: 32,
                  width: 32,
                  radius: 100,
                  fit: BoxFit.cover,
                  url: merchantLogo!,
                ),
              if (merchantLogo != null) SizedBox(width: 10),
              Expanded(
                child: MyText(
                  text: merchantName,
                  size: 18,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          MyText(
            text: 'Locations (${locations.length})',
            size: 16,
            weight: FontWeight.w600,
            paddingBottom: 12,
          ),
          Expanded(
            child: locations.isEmpty
                ? Center(
                    child: MyText(
                      text: 'No locations available',
                      size: 14,
                      color: kQuaternaryColor,
                    ),
                  )
                : ListView.builder(
                    padding: AppSizes.ZERO,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: locations.length,
                    itemBuilder: (context, i) {
                      final location = locations[i];
                      return _LocationTile(location: location);
                    },
                  ),
          ),
          SizedBox(height: 16),
          MyButton(
            buttonText: 'Close',
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({required this.location});

  final Map<String, dynamic> location;

  @override
  Widget build(BuildContext context) {
    final address = location['address'] as String? ?? 'No address';
    final lat = location['lat'] as double? ?? 0.0;
    final lng = location['lng'] as double? ?? 0.0;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kFillColor,
        border: Border.all(color: kBorderColor, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kLightBlueColor2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(Assets.imagesLoc, height: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: address,
                  size: 14,
                  weight: FontWeight.w500,
                  maxLines: 2,
                ),
                if (lat != 0.0 || lng != 0.0) ...[
                  SizedBox(height: 4),
                  MyText(
                    text: 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}',
                    size: 11,
                    color: kQuaternaryColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferTile extends StatelessWidget {
  const _OfferTile({required this.offer});

  final dynamic offer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back(); // Close the merchant offers sheet
        Get.bottomSheet(
          UOfferDetails(offer: offer),
          isScrollControlled: true,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kFillColor,
          border: Border.all(color: kBorderColor, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            CommonImageView(
              url: offer.merchantLogo ?? dummyImg,
              height: 38,
              width: 38,
              fit: BoxFit.cover,
              radius: 100,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: offer.title,
                    size: 15,
                    weight: FontWeight.w600,
                    paddingBottom: 4,
                  ),
                  MyText(
                    text: '${offer.merchantBrand ?? 'Merchant'} - "${offer.couponCode ?? 'No Code'}"',
                    size: 12,
                    color: kQuaternaryColor,
                  ),
                ],
              ),
            ),
            Image.asset(Assets.imagesMore, height: 24),
          ],
        ),
      ),
    );
  }
}


// Keep this for marker clicks (shows offers)
class _ViewSponsorDetails extends StatelessWidget {
  final String title;
  final String image;
  final List<dynamic> offers;

  const _ViewSponsorDetails({
    super.key,
    required this.title,
    required this.image,
    required this.offers,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 55),
      height: Get.height * 0.9,
      width: Get.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CommonImageView(
                height: 32,
                width: 32,
                radius: 100,
                fit: BoxFit.cover,
                url: image,
              ),
              Expanded(
                child: MyText(
                  text: title,
                  size: 18,
                  weight: FontWeight.w600,
                  paddingLeft: 10,
                ),
              ),
              MyText(
                text: '4.8/5.0',
                size: 20,
                weight: FontWeight.w600,
                paddingRight: 4,
              ),
              Image.asset(Assets.imagesStarIcon, height: 20),
            ],
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: AppSizes.ZERO,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: offers.length,
              itemBuilder: (context, i) {
                final offer = offers[i];
                return _OfferTile(offer: offer);
              },
            ),
          ),
          SizedBox(height: 16),
          MyButton(
            buttonText: 'Close',
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}

// Custom marker overlay widget that follows map position
class _CustomMarkerOverlay extends StatefulWidget {
  final GoogleMapController mapController;
  final LatLng position;
  final String merchantName;
  final String merchantLogo;
  final int offerCount;
  final VoidCallback onTap;

  const _CustomMarkerOverlay({
    required this.mapController,
    required this.position,
    required this.merchantName,
    required this.merchantLogo,
    required this.offerCount,
    required this.onTap,
  });

  @override
  State<_CustomMarkerOverlay> createState() => _CustomMarkerOverlayState();
}

class _CustomMarkerOverlayState extends State<_CustomMarkerOverlay> {
  Offset? _screenPosition;

  @override
  void initState() {
    super.initState();
    _updatePosition();
    // Update position when map moves
    widget.mapController.getVisibleRegion().then((_) => _updatePosition());
  }

  Future<void> _updatePosition() async {
    try {
      final screenCoordinate = await widget.mapController.getScreenCoordinate(widget.position);
      if (mounted) {
        setState(() {
          _screenPosition = Offset(screenCoordinate.x.toDouble(), screenCoordinate.y.toDouble());
        });
      }
    } catch (e) {
      // Error updating marker position
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_screenPosition == null) return SizedBox.shrink();

    return Positioned(
      left: _screenPosition!.dx - 75, // Center the bubble (150/2)
      top: _screenPosition!.dy - 22, // Position above the point (44/2)
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: 44,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: kBorderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: kTertiaryColor.withValues(alpha: .16),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonImageView(
                height: 24,
                width: 24,
                radius: 100,
                fit: BoxFit.cover,
                url: widget.merchantLogo,
              ),
              SizedBox(width: 6),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: widget.merchantName,
                    size: 12,
                    weight: FontWeight.w600,
                    paddingBottom: 2,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  MyText(
                    text: '${widget.offerCount} Offer${widget.offerCount > 1 ? 's' : ''}',
                    size: 10,
                    color: kQuaternaryColor,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }
}
