import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_fonts.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/models/offer_model.dart';
import 'package:snag/services/client_offers_service.dart';
import 'package:snag/view/screens/user/user_my_offers/u_offer_redeemed.dart';
import 'package:snag/view/screens/user/user_my_offers/u_snag_it.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_bottom_sheet_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UOfferDetails extends StatefulWidget {
  final OfferModel? offer;
  
  const UOfferDetails({super.key, this.offer});
  
  @override
  State<UOfferDetails> createState() => _UOfferDetailsState();
}

class _UOfferDetailsState extends State<UOfferDetails> {
  final _offersService = ClientOffersService.instance;
  bool _isSaving = false;
  bool _isSnagging = false;
  late bool _isSaved;
  bool _hasRedeemed = false;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.offer?.isSaved ?? false;
    _hasRedeemed = widget.offer?.hasRedeemed ?? false;
  }

  Future<void> _toggleSave() async {
    if (widget.offer == null || _isSaving) return;

    setState(() => _isSaving = true);

    try {
      print('💾 [OfferDetails] Toggling save for offer: ${widget.offer!.id}');
      
      final result = _isSaved
          ? await _offersService.unsaveOffer(widget.offer!.id)
          : await _offersService.saveOffer(widget.offer!.id);

      result
          .onSuccess((saved) {
        print('✅ [OfferDetails] Save toggled successfully: $saved');
        setState(() => _isSaved = saved);
        Get.snackbar(
          saved ? 'Saved' : 'Removed',
          saved ? 'Offer saved for later' : 'Offer removed from saved',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: kSecondaryColor,
          colorText: kPrimaryColor,
        );
      })
          .onFailure((error) {
        print('❌ [OfferDetails] Save toggle failed: ${error.message}');
        Get.snackbar(
          'Error',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _handleSnag() async {
    if (widget.offer == null || _isSnagging) return;

    setState(() => _isSnagging = true);

    try {
      print('🎯 [OfferDetails] Snagging offer: ${widget.offer!.id}');
      
      final result = await _offersService.snagOffer(widget.offer!.id);

      result
          .onSuccess((redemption) {
        print('✅ [OfferDetails] Offer snagged successfully');
        setState(() => _hasRedeemed = true); // Update state
        Get.back(); // Close confirmation dialog
        Get.off(() => UOfferRedeemed(redemption: redemption)); // Replace current screen
      })
          .onFailure((error) {
        print('❌ [OfferDetails] Snag failed: ${error.message}');
        Get.back(); // Close confirmation dialog
        Get.snackbar(
          'Cannot Snag Offer',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      });
    } finally {
      setState(() => _isSnagging = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    // Use offer data if available, otherwise use hardcoded data
    final title = widget.offer?.title ?? "Weekend Flash Deal — 15% Off";
    final description = widget.offer?.description ?? 
        "Get 15% off your total bill this weekend only. Valid on all items, dine-in or takeaway. Not valid with other offers.";
    
    final dateFormat = DateFormat('d MMMM, yyyy');
    final startDate = widget.offer != null 
        ? dateFormat.format(widget.offer!.startDate)
        : '9 August, 2025';
    final endDate = widget.offer != null
        ? dateFormat.format(widget.offer!.endDate)
        : '21 August, 2025';
    
    return Container(
      height: Get.height * 0.9,
      width: Get.width,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          simpleAppBar(
            title: '',
            actions: [
              PopupMenuButton<String>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: BoxConstraints(minWidth: 48, maxWidth: 160),
                padding: EdgeInsets.zero,
                offset: Offset(0, 30),
                icon: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Image.asset(Assets.imagesMore, height: 28),
                  ),
                ),
                onSelected: (value) {},
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        height: 30,
                        value: 'Save',
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: AppFonts.WORK_SANS,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        height: 30,
                        value: 'Share',
                        child: Text(
                          'Share',
                          style: TextStyle(
                            fontFamily: AppFonts.WORK_SANS,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        height: 30,
                        value: 'Send To Friends',
                        child: Text(
                          'Send To Friends',
                          style: TextStyle(
                            fontFamily: AppFonts.WORK_SANS,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
              ),

              SizedBox(width: 5),
            ],
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: title,
                  size: 24,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text: description,
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 30,
                ),
                _basicInfo(startDate, endDate),
                SizedBox(height: 30),
                MyBorderButton(
                  buttonText: _isSaved ? 'Saved ✓' : 'Save for later',
                  onTap: _isSaving ? () {} : _toggleSave,
                  bgColor: _isSaved ? kSecondaryColor.withOpacity(0.1) : null,
                  textColor: _isSaved ? kSecondaryColor : null,
                  borderColor: _isSaved ? kSecondaryColor : null,
                ),
                SizedBox(height: 12),
                MyButton(
                  buttonText: _hasRedeemed
                      ? 'Snagged' 
                      : (_isSnagging ? 'Snagging...' : 'Snag It'),
                  onTap: _hasRedeemed
                      ? () {} 
                      : (_isSnagging ? () {} : () {
                          Get.dialog(_snagIt());
                        }),
                  bgColor: _hasRedeemed
                      ? kTertiaryColor 
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _basicInfo(String startDate, String endDate) {
    // Use real offer data if available
    if (widget.offer != null) {
      final firstLocation = widget.offer!.locations.isNotEmpty 
          ? widget.offer!.locations.first 
          : null;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 30),
          Center(
            child: CommonImageView(
              height: 250,
              width: 250,
              fit: BoxFit.cover,
              url: widget.offer!.merchantLogo ?? Assets.imagesKfc,
            ),
          ),
          SizedBox(height: 20),
          // Location
          if (firstLocation != null && firstLocation.address != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Assets.imagesBank, height: 28),
                  Expanded(
                    child: MyText(
                      paddingLeft: 10,
                      text: firstLocation.address!,
                      size: 16,
                      weight: FontWeight.w500,
                      paddingRight: 10,
                    ),
                  ),
                  Image.asset(Assets.imagesDirections, height: 24),
                ],
              ),
            ),
          // Offer Type
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(Assets.imagesDt, height: 28),
                Expanded(
                  child: MyText(
                    paddingLeft: 10,
                    text: widget.offer!.offerType,
                    size: 16,
                    weight: FontWeight.w500,
                    paddingRight: 10,
                  ),
                ),
              ],
            ),
          ),
          // Date Range
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(Assets.imagesTime, height: 28),
                Expanded(
                  child: MyText(
                    paddingLeft: 10,
                    text: '$startDate - $endDate',
                    size: 16,
                    weight: FontWeight.w500,
                    paddingRight: 10,
                  ),
                ),
              ],
            ),
          ),
          // Merchant Brand
          if (widget.offer!.merchantBrand != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(Assets.imagesLocationType, height: 28),
                  Expanded(
                    child: MyText(
                      paddingLeft: 10,
                      text: widget.offer!.merchantBrand!,
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
    
    // Fallback to hardcoded data for sponsored offers
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Center(
          child: CommonImageView(
            height: 250,
            width: 250,
            fit: BoxFit.cover,
            imagePath: Assets.imagesKfc,
          ),
        ),
        SizedBox(height: 20),
        ...List.generate(4, (index) {
          final List<Map<String, String>> details = [
            {
              'icon': Assets.imagesBank,
              'value': 'XYS Street,  123 lane, 34660, San Francisco Bay Area.',
            },
            {'icon': Assets.imagesDt, 'value': 'In-Store'},
            {
              'icon': Assets.imagesTime,
              'value': '$startDate - $endDate',
            },
            {'icon': Assets.imagesLocationType, 'value': 'Main Branch'},
          ];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(details[index]['icon']!, height: 28),
                Expanded(
                  child: MyText(
                    paddingLeft: 10,
                    text: details[index]['value']!,
                    size: 16,
                    weight: FontWeight.w500,
                    paddingRight: 10,
                  ),
                ),
                if (index == 0)
                  Image.asset(Assets.imagesDirections, height: 24),
              ],
            ),
          );
        }),
      ],
    );
  }

  Column _snagIt() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Container(
            margin: AppSizes.DEFAULT,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kFillColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kBorderColor, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(Assets.imagesSnagIt, height: 48),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Image.asset(Assets.imagesCloseIcon, height: 14),
                      ),
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'Snag this offer?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Snagging this deal will lock it for use. Some offers can only be used once and may expire shortly after redemption. Make sure you’re ready to show this at the counter.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                MyButton(
                  height: 42,
                  buttonText: _isSnagging ? 'Processing...' : 'Confirm',
                  onTap: _isSnagging ? () {} : _handleSnag,
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  borderColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
