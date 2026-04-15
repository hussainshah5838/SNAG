import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/constants/app_constants.dart';
import 'package:snag/controllers/merchant_onboarding_controller.dart';
import 'package:snag/view/screens/merchant/settings/locations/bulk_locations_upload.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class AddNewBusinessLocation extends StatefulWidget {
  const AddNewBusinessLocation({super.key});

  @override
  State<AddNewBusinessLocation> createState() => _AddNewBusinessLocationState();
}

class _AddNewBusinessLocationState extends State<AddNewBusinessLocation> {
  final _controller = Get.find<MerchantOnboardingController>();
  final _addressController = TextEditingController();
  final _branchAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _address = "";
  String _state = "";
  String _country = "";
  String _branchAddress = "";
  double? _latitude;
  double? _longitude;
  String _locationType = LocationTypes.main;
  String _phoneNumber = "";
  String _email = "";
  File? _bannerFile;
  String _bannerFileName = "";
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _branchAddressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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

  Future<void> _saveLocation() async {
    // Validation
    if (_branchAddress.isEmpty) {
      Get.snackbar('Error', 'Please enter branch name', backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }
    if (_address.isEmpty) {
      Get.snackbar('Error', 'Please select an address', backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }
    if (_state.isEmpty || _country.isEmpty) {
      Get.snackbar('Error', 'Please select address to auto-fill state and country', backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }
    if (_latitude == null || _longitude == null) {
      Get.snackbar('Error', 'Please select address to auto-fill coordinates', backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }
    if (_phoneNumber.isEmpty) {
      Get.snackbar('Error', 'Please enter phone number', backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }
    if (_email.isEmpty) {
      Get.snackbar('Error', 'Please enter email', backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }

    setState(() => _isLoading = true);

    final success = await _controller.addLocation(
      address: _address,
      state: _state,
      country: _country,
      branchAddress: _branchAddress,
      locationType: _locationType,
      lat: _latitude!,
      lng: _longitude!,
      bannerFile: _bannerFile,
      phoneNumber: _phoneNumber,
      email: _email,
    );

    setState(() => _isLoading = false);

    if (success) {
      Get.snackbar('Success', 'Location added successfully', backgroundColor: Colors.green, colorText: Colors.white);
      
      // Clear all fields
      setState(() {
        _address = "";
        _state = "";
        _country = "";
        _branchAddress = "";
        _latitude = null;
        _longitude = null;
        _locationType = LocationTypes.main;
        _phoneNumber = "";
        _email = "";
        _bannerFile = null;
        _bannerFileName = "";
      });
      _addressController.clear();
      _branchAddressController.clear();
      _phoneController.clear();
      _emailController.clear();
      
      // Refresh list and go back
      _controller.fetchLocations();
      Get.back(); // Go back to locations list
    } else {
      Get.snackbar('Error', _controller.errorMsg.value, backgroundColor: kRedColor, colorText: kPrimaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: kSecondaryColor))
          : ListView(
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
                  text: "Add a new location with address, coordinates, and contact information.",
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                ),
                MyText(
                  onTap: () => Get.to(() => BulkLocationsUpload()),
                  text: 'Bulk Upload',
                  size: 16,
                  weight: FontWeight.w600,
                  color: kSecondaryColor,
                  paddingBottom: 30,
                  paddingTop: 12,
                  textAlign: TextAlign.end,
                ),

                // Branch Address
                MyTextField(
                  controller: _branchAddressController,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesName, height: 20)],
                  ),
                  labelText: 'Branch Name',
                  hintText: 'Enter branch name',
                  isMandatory: true,
                  onChanged: (val) => _branchAddress = val,
                ),

                // Address (simple text field)
                MyTextField(
                  controller: _addressController,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesLoc, height: 20)],
                  ),
                  labelText: 'Address',
                  hintText: 'Enter address',
                  isMandatory: true,
                  onChanged: (val) => _address = val,
                ),

                // State (editable)
                MyTextField(
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesCountryIcon, height: 20)],
                  ),
                  labelText: 'State',
                  hintText: 'Enter state',
                  isMandatory: true,
                  onChanged: (val) => _state = val,
                ),

                // Country (editable)
                MyTextField(
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesCountryIcon, height: 20)],
                  ),
                  labelText: 'Country',
                  hintText: 'Enter country',
                  isMandatory: true,
                  onChanged: (val) => _country = val,
                ),

                // Latitude (editable)
                MyTextField(
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesLat, height: 20)],
                  ),
                  labelText: 'Latitude',
                  hintText: 'Enter latitude',
                  isMandatory: true,
                  onChanged: (val) => _latitude = double.tryParse(val),
                ),

                // Longitude (editable)
                MyTextField(
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesLong, height: 20)],
                  ),
                  labelText: 'Longitude',
                  hintText: 'Enter longitude',
                  isMandatory: true,
                  onChanged: (val) => _longitude = double.tryParse(val),
                ),

                // Location Type
                CustomDropDown(
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesLocationType, height: 20)],
                  ),
                  labelText: 'Location Type',
                  hint: 'Select Location Type',
                  isMandatory: true,
                  items: [LocationTypes.main, LocationTypes.franchise],
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
                  onChanged: (val) => _phoneNumber = val,
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
                  onChanged: (val) => _email = val,
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Add Location',
          onTap: _saveLocation,
        ),
      ),
    );
  }
}
