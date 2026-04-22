import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_offers_controller.dart';
import 'package:snag/view/screens/merchant/offers/edit_offer.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

class OfferDetails extends StatefulWidget {
  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  final controller = Get.put(MerchantOffersController());
  int? selectedLabelIndex = 0;
  String? offerId;

  @override
  void initState() {
    super.initState();
    // Get offerId from navigation arguments
    offerId = Get.arguments as String?;
    if (offerId != null) {
      controller.fetchOfferById(offerId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> labels = ["Basic Info", "Redemptions", "Stats"];
    
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () async {
                if (offerId != null) {
                  final result = await Get.to(() => EditOffer(), arguments: offerId);
                  // If offer was deleted, go back to list
                  if (result == 'deleted') {
                    Get.back(result: true); // Go back to offers list with refresh signal
                  } else if (result == true) {
                    // Offer was edited, refresh details
                    controller.fetchOfferById(offerId!);
                  }
                }
              },
              child: Image.asset(Assets.imagesEditIcon, height: 20),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingOffer.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.offerError.value != null) {
          return Center(
            child: MyText(
              text: 'Error: ${controller.offerError.value}',
              color: Colors.red,
            ),
          );
        }

        final offer = controller.currentOffer.value;
        if (offer == null) {
          return Center(
            child: MyText(text: 'Offer not found'),
          );
        }

        return ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            Row(
              children: [
                Expanded(
                  child: MyText(
                    text: offer['title'] as String? ?? 'Untitled Offer',
                    size: 24,
                    weight: FontWeight.w600,
                    paddingBottom: 8,
                  ),
                ),
                if ((offer['status'] as String? ?? 'draft') == 'draft')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: MyText(
                      text: 'DRAFT',
                      size: 12,
                      weight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
              ],
            ),
            MyText(
              text: offer['description'] as String? ?? 'No description',
              size: 16,
              lineHeight: 1.5,
              weight: FontWeight.w500,
              color: kQuaternaryColor,
              paddingBottom: 30,
            ),
            SizedBox(
              height: 35,
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10);
                },
                padding: AppSizes.ZERO,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: labels.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedLabelIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLabelIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? kSecondaryColor : kLightBlueColor2,
                        border: Border.all(color: kBlueBorderColor),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: MyText(
                          text: labels[index],
                          size: 13,
                          weight: FontWeight.w500,
                          color: isSelected ? kPrimaryColor : kSecondaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            selectedLabelIndex == 0
                ? _basicInfo(offer)
                : selectedLabelIndex == 1
                ? _redemption(offer)
                : _stats(offer),
          ],
        );
      }),
    );
  }

  Column _basicInfo(Map<String, dynamic> offer) {
    final bannerUrl = offer['bannerUrl'] as String?;
    final offerType = offer['offerType'] as String? ?? 'in-store';
    final startDate = offer['startDate'] as String?;
    final endDate = offer['endDate'] as String?;
    
    // Format dates
    String dateRange = 'No dates specified';
    if (startDate != null && endDate != null) {
      try {
        final start = DateTime.parse(startDate);
        final end = DateTime.parse(endDate);
        dateRange = '${start.day} ${_getMonthName(start.month)}, ${start.year} - ${end.day} ${_getMonthName(end.month)}, ${end.year}';
      } catch (e) {
        dateRange = 'Invalid date format';
      }
    }
    
    // Get location info
    final locations = offer['locationIds'] as List<dynamic>?;
    String locationName = 'No location specified';
    String locationAddress = 'No address available';
    if (locations != null && locations.isNotEmpty) {
      final firstLocation = locations[0] as Map<String, dynamic>?;
      if (firstLocation != null) {
        locationName = firstLocation['branchAddress'] as String? ?? firstLocation['address'] as String? ?? 'Unknown location';
        locationAddress = firstLocation['address'] as String? ?? 'No address';
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Center(
          child: CommonImageView(
            height: 250,
            width: 250,
            radius: 12,
            fit: BoxFit.contain,
            url: bannerUrl,
            imagePath: bannerUrl == null ? Assets.imagesKfc : null,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.imagesBank, height: 28),
              Expanded(
                child: MyText(
                  paddingLeft: 10,
                  text: locationAddress,
                  size: 16,
                  weight: FontWeight.w500,
                  paddingRight: 10,
                ),
              ),
              Image.asset(Assets.imagesDirections, height: 24),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.imagesDt, height: 28),
              Expanded(
                child: MyText(
                  paddingLeft: 10,
                  text: offerType == 'online' ? 'Online' : 'In-Store',
                  size: 16,
                  weight: FontWeight.w500,
                  paddingRight: 10,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.imagesTime, height: 28),
              Expanded(
                child: MyText(
                  paddingLeft: 10,
                  text: dateRange,
                  size: 16,
                  weight: FontWeight.w500,
                  paddingRight: 10,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.imagesLocationType, height: 28),
              Expanded(
                child: MyText(
                  paddingLeft: 10,
                  text: locationName,
                  size: 16,
                  weight: FontWeight.w500,
                  paddingRight: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Column _redemption(Map<String, dynamic> offer) {
    final couponCode = offer['couponCode'] as String?;
    final qrCodeUrl = offer['qrCodeUrl'] as String?;
    final barCodeUrl = offer['barCodeUrl'] as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        if (couponCode != null)
          Row(
            children: [
              MyText(
                text: 'Coupon Code: ',
                size: 16,
                weight: FontWeight.w500,
                color: Colors.black,
                paddingBottom: 30,
              ),
              MyText(
                text: '"$couponCode"',
                size: 24,
                weight: FontWeight.w600,
                color: Colors.black,
                paddingBottom: 30,
              ),
            ],
          ),
        if (qrCodeUrl != null)
          Center(
            child: Image.network(
              qrCodeUrl,
              height: 180,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(Assets.imagesQr, height: 180, color: Colors.black);
              },
            ),
          )
        else
          Center(
            child: Image.asset(Assets.imagesQr, height: 180, color: Colors.black),
          ),
        SizedBox(height: 28),
        if (barCodeUrl != null)
          Center(
            child: Image.network(
              barCodeUrl,
              height: 90,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(Assets.imagesBarCode, height: 90, color: Colors.black);
              },
            ),
          )
        else
          Center(
            child: Image.asset(
              Assets.imagesBarCode,
              height: 90,
              color: Colors.black,
            ),
          ),
      ],
    );
  }

  Column _stats(Map<String, dynamic> offer) {
    final stats = offer['stats'] as Map<String, dynamic>?;
    final views = stats?['views'] as int? ?? 0;
    final clicks = stats?['clicks'] as int? ?? 0;
    final redemptions = stats?['redemptions'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: AppSizes.ZERO,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 122,
          ),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            final List<Map<String, dynamic>> statsData = [
              {
                'icon': Assets.imagesViews,
                'percent': '0%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Views',
                'value': views.toString(),
              },
              {
                'icon': Assets.imagesCtr,
                'percent': '0%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Clicks',
                'value': clicks.toString(),
              },
              {
                'icon': Assets.imagesRedemptions,
                'percent': '0%',
                'percentColor': kGreenColor,
                'percentText': ' vs Last Month',
                'label': 'Redemptions',
                'value': redemptions.toString(),
              },
              {
                'icon': Assets.imagesTopBranch,
                'percent': '',
                'percentColor': kTertiaryColor,
                'percentText': '',
                'label': 'Top Branch',
                'value': 'N/A',
              },
            ];
            final stat = statsData[index];
            return Container(
              decoration: BoxDecoration(
                color: kFillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorderColor, width: 1.0),
              ),
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Image.asset(stat['icon'], height: 24, width: 24),
                      Expanded(
                        child: RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: stat['percent'],
                                style: TextStyle(
                                  fontFamily: AppFonts.WORK_SANS,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: stat['percentColor'],
                                ),
                              ),
                              TextSpan(
                                text: stat['percentText'],
                                style: TextStyle(
                                  color: kTertiaryColor,
                                  fontFamily: AppFonts.WORK_SANS,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  MyText(
                    text: stat['label'],
                    size: 14,
                    weight: FontWeight.w500,
                    paddingBottom: 6,
                  ),
                  MyText(
                    text: stat['value'],
                    size: 24,
                    fontFamily: GoogleFonts.dmSans().fontFamily,
                    weight: FontWeight.w700,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
