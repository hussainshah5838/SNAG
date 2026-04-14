import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/constants/app_constants.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  AddLocationState createState() => AddLocationState();
}

class AddLocationState extends State<AddLocation> {
  final _addressController       = TextEditingController();
  final _stateController         = TextEditingController();
  final _countryController       = TextEditingController();
  final _branchAddressController = TextEditingController();
  final _latController           = TextEditingController();
  final _lngController           = TextEditingController();
  final _phoneController         = TextEditingController();
  final _emailController         = TextEditingController();

  // 'main' or 'franchise' — matches backend LocationTypes constant
  String _locationType = LocationTypes.franchise;
  File? _bannerFile;
  String _bannerFileName = "";

  Future<void> _pickBanner() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _bannerFile = File(pickedFile.path);
        _bannerFileName = pickedFile.path.split('/').last;
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _branchAddressController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Called by CompleteProfile Next button on this step.
  /// Returns validated data map or null if validation fails.
  Map<String, dynamic>? getFormData() {
    final lat = double.tryParse(_latController.text.trim());
    final lng = double.tryParse(_lngController.text.trim());

    if (_addressController.text.trim().isEmpty ||
        _stateController.text.trim().isEmpty ||
        _countryController.text.trim().isEmpty ||
        _branchAddressController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        lat == null || lng == null) {
      Get.snackbar('Error', 'Please fill in all required fields',
          backgroundColor: kRedColor, colorText: kPrimaryColor);
      return null;
    }

    return {
      'address':       _addressController.text.trim(),
      'state':         _stateController.text.trim(),
      'country':       _countryController.text.trim(),
      'branchAddress': _branchAddressController.text.trim(),
      'locationType':  _locationType,
      'lat':           lat,
      'lng':           lng,
      'bannerFile':    _bannerFile,
      'phoneNumber':   _phoneController.text.trim(),
      'email':         _emailController.text.trim(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: AppSizes.DEFAULT,
      physics: BouncingScrollPhysics(),
      children: [
        MyText(
          text: "Add Location",
          paddingTop: 8,
          size: 24,
          weight: FontWeight.w600,
          paddingBottom: 8,
        ),
        MyText(
          text: "Select your country, state, and location type (Franchise or Main Branch) to complete your profile.",
          size: 16,
          lineHeight: 1.5,
          weight: FontWeight.w500,
          color: kQuaternaryColor,
          paddingBottom: 30,
        ),
        // Address
        MyTextField(
          controller: _addressController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesLoc, height: 20)],
          ),
          labelText: 'Address',
          hintText: 'Enter address',
          isMandatory: true,
        ),
        // State
        MyTextField(
          controller: _stateController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCountryIcon, height: 20)],
          ),
          labelText: 'State',
          hintText: 'Enter state',
          isMandatory: true,
        ),
        // Country
        MyTextField(
          controller: _countryController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCountryIcon, height: 20)],
          ),
          labelText: 'Country',
          hintText: 'Enter country',
          isMandatory: true,
        ),
        // Branch Address
        MyTextField(
          controller: _branchAddressController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesLoc, height: 20)],
          ),
          labelText: 'Branch Address',
          hintText: 'Enter branch address',
          isMandatory: true,
        ),
        // Latitude
        MyTextField(
          controller: _latController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesLat, height: 20)],
          ),
          labelText: 'Latitude',
          hintText: '31.5204',
          isMandatory: true,
        ),
        // Longitude
        MyTextField(
          controller: _lngController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesLong, height: 20)],
          ),
          labelText: 'Longitude',
          hintText: '74.3587',
          isMandatory: true,
        ),
        // Location Type
        CustomDropDown(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTag, height: 20)],
          ),
          labelText: 'Location Type',
          hint: 'Select Location Type',
          isMandatory: true,
          items: [LocationTypes.franchise, LocationTypes.main],
          selectedValue: _locationType,
          onChanged: (val) => setState(() => _locationType = val),
        ),
        // Upload Banner/Image
        MyTextField(
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesProof, height: 20)],
          ),
          suffix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesUpload, height: 16)],
          ),
          isReadOnly: true,
          onTap: _pickBanner,
          labelText: 'Upload Banner/Image',
          hintText: _bannerFileName.isEmpty ? 'Select banner image' : _bannerFileName,
          isMandatory: false,
        ),
        // Phone Number (mandatory)
        MyTextField(
          controller: _phoneController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPhone, height: 20)],
          ),
          labelText: 'Location Phone Number',
          hintText: '+971 322 323 2323',
          isMandatory: true,
        ),
        // Email (mandatory)
        MyTextField(
          controller: _emailController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesEmail, height: 20)],
          ),
          labelText: 'Location Email',
          hintText: 'location@example.com',
          isMandatory: true,
        ),
      ],
    );
  }
}
