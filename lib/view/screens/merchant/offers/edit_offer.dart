import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditOffer extends StatefulWidget {
  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  String _selectedOfferType = 'Select offer type or category...';
  String _selectedScanType = 'Percentage Off';
  int? selectedLabelIndex = 0;
  final List<String> labels = ["Basic Info", "Scan Info", "Location Info"];
  final List<String> _keywords = [
    'Buy 1 Get 1',
    'Flash Deal',
    'Discount %',
    'Food & Drink',
  ];
  final List<String> _statuses = ['Active', 'Expired', 'Scheduled'];
  final List<String> _branches = [
    'Downtown Outlet',
    'Gulberg Branch',
    'DHA Phase 6 Outlet',
  ];
  List<String> _selectedStatusesList = [];
  List<String> _selectedBranchesList = [];
  List<String> _selectedKeywordsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.dialog(_deleteDiscount());
              },
              child: Image.asset(Assets.imagesTrash, height: 20),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.DEFAULT,
        physics: BouncingScrollPhysics(),
        children: [
          MyText(
            text: "Edit Offer",
            size: 24,
            weight: FontWeight.w600,
            paddingBottom: 4,
          ),
          MyText(
            text: "Edit your offer to attract customers and boost redemptions",
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
              ? _basicInfo()
              : selectedLabelIndex == 1
              ? _scanInfo()
              : _locationInfo(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Save Details',
          onTap: () {
            Get.back();
          },
        ),
      ),
    );
  }

  Column _basicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTt, height: 20)],
          ),
          labelText: 'Discount Title',
          hintText: 'Weekend Flash Deal — 15% Off',
          isMandatory: true,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTt, height: 20)],
          ),
          labelText: 'Description',
          hintText:
              'Get 15% off your total bill this weekend only. Valid on all items, dine-in or takeaway. Not valid with other offers.',
          isMandatory: true,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesProof, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'Upload Banner/Image',
          hintText: 'weekend_flash_deal_banner.jpg',
          isMandatory: true,
        ),
        CustomDropDown(
          labelText: 'Offer Type ',
          hint: 'Select offer type or category...',
          items: ['Select offer type or category...', 'In Store'],
          selectedValue: _selectedOfferType,
          prefix: Image.asset(Assets.imagesTag, height: 20),
          onChanged: (v) => setState(() => _selectedOfferType = v),
        ),
        MultiDropDown(
          labelText: 'Category / Tags',
          hint: 'E.g., Food & Drink, Shopping',
          isMandatory: false,
          items: _keywords,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTag, height: 20)],
          ),
          selectedValues: _selectedKeywordsList,
          onTap: (String value) {
            setState(() {
              if (_selectedKeywordsList.contains(value)) {
                _selectedKeywordsList.remove(value);
              } else {
                _selectedKeywordsList.add(value);
              }
            });
          },
        ),
        MultiDropDown(
          labelText: 'Status',
          hint: 'Select offer status e.g. Active, Expired',
          isMandatory: false,
          items: _statuses,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTag, height: 20)],
          ),
          selectedValues: _selectedStatusesList,
          onTap: (value) {
            setState(() {
              if (_selectedStatusesList.contains(value)) {
                _selectedStatusesList.remove(value);
              } else {
                _selectedStatusesList.add(value);
              }
            });
          },
        ),
      ],
    );
  }

  Column _scanInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        CustomDropDown(
          labelText: 'Type',
          hint: 'change the type of offer',
          items: ['Percentage Off', 'Amount Off', 'Buy X Get Y'],
          selectedValue: _selectedScanType,
          prefix: Image.asset(Assets.imagesTag, height: 20),
          onChanged: (v) => setState(() => _selectedScanType = v),
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          labelText: 'Redemption Limit',
          hintText: '100',
          isMandatory: false,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          labelText: 'Coupon Code',
          hintText: 'SAVE15',
          isMandatory: false,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'QR Code',
          hintText: 'qr.png',
          isMandatory: false,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPoints, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          labelText: 'Bar Code',
          hintText: 'Bar.png',
          isMandatory: false,
        ),
      ],
    );
  }

  Column _locationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        MultiDropDown(
          labelText: 'Branch / Outlet',
          hint: 'Select branch or outlet',
          isMandatory: false,
          items: _branches,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTag, height: 20)],
          ),
          selectedValues: _selectedBranchesList,
          onTap: (value) {
            setState(() {
              if (_selectedBranchesList.contains(value)) {
                _selectedBranchesList.remove(value);
              } else {
                _selectedBranchesList.add(value);
              }
            });
          },
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCalendar, height: 20)],
          ),
          labelText: 'Start Date',
          hintText: '9 August, 2025',
          isMandatory: false,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesClock, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesStopWatch, height: 20)],
          ),
          labelText: 'Start Time',
          hintText: '9 August, 2025',
          isMandatory: false,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCalendar, height: 20)],
          ),
          labelText: 'End Date',
          hintText: '21 August, 2025',
          isMandatory: false,
        ),
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesClock, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesStopWatch, height: 20)],
          ),
          labelText: 'End Time',
          hintText: '21 August, 2025',
          isMandatory: false,
        ),
      ],
    );
  }
}

Column _deleteDiscount() {
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
                  Image.asset(Assets.imagesDeleteProfile, height: 48),
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
                text: 'Delete Discount?',
                size: 20,
                weight: FontWeight.w600,
                paddingBottom: 8,
              ),
              MyText(
                text:
                    'Are you sure you want to delete this discount? This action cannot be undone and customers will no longer see or redeem this offer.',
                size: 15,
                lineHeight: 1.5,
                weight: FontWeight.w500,
                color: kQuaternaryColor,
                paddingBottom: 24,
              ),

              MyButton(
                height: 42,
                buttonText: 'Delete Discount',
                onTap: () {
                  Get.back();
                  // Add your logout logic here
                },
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
