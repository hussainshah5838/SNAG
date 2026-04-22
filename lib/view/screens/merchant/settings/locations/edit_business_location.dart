import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_onboarding_controller.dart';
import 'package:snag/services/merchant_onboarding_service.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EditBusinessLocation extends StatefulWidget {
  final String? locationId;
  final Map<String, dynamic>? locationData;
  
  const EditBusinessLocation({
    super.key,
    this.locationId,
    this.locationData,
  });

  @override
  State<EditBusinessLocation> createState() => _EditBusinessLocationState();
}

class _EditBusinessLocationState extends State<EditBusinessLocation> {
  final _service = MerchantOnboardingService.instance;
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
  String _locationType = 'main';
  String _phoneNumber = "";
  String _email = "";
  File? _bannerFile;
  String _bannerFileName = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  void _loadLocationData() {
    if (widget.locationData != null) {
      final data = widget.locationData!;
      setState(() {
        _address = data['address'] as String? ?? '';
        _state = data['state'] as String? ?? '';
        _country = data['country'] as String? ?? '';
        _branchAddress = data['branchAddress'] as String? ?? '';
        _locationType = data['locationType'] as String? ?? 'main';
        
        final coords = data['coordinates'] as Map<String, dynamic>?;
        if (coords != null) {
          _latitude = (coords['lat'] as num?)?.toDouble();
          _longitude = (coords['lng'] as num?)?.toDouble();
        }
        
        final branchInfo = data['branchInfo'] as Map<String, dynamic>?;
        if (branchInfo != null) {
          _phoneNumber = branchInfo['phoneNumber'] as String? ?? '';
          _email = branchInfo['email'] as String? ?? '';
        }
        
        _addressController.text = _address;
        _branchAddressController.text = _branchAddress;
        _phoneController.text = _phoneNumber;
        _emailController.text = _email;
      });
    }
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
    if (widget.locationId == null) return;
    
    setState(() => _isLoading = true);
    
    final result = await _service.editLocation(
      locationId: widget.locationId!,
      address: _address,
      state: _state,
      country: _country,
      branchAddress: _branchAddress,
      locationType: _locationType,
      lat: _latitude,
      lng: _longitude,
      bannerFile: _bannerFile,
      phoneNumber: _phoneNumber.isEmpty ? null : _phoneNumber,
      email: _email.isEmpty ? null : _email,
    );
    
    setState(() => _isLoading = false);
    
    result
        .onSuccess((message) {
          Get.snackbar('Success', message, backgroundColor: Colors.green, colorText: Colors.white);
          // Refresh locations list
          final controller = Get.find<MerchantOnboardingController>();
          controller.fetchLocations();
          Get.back();
          Get.back(); // Go back to locations list
        })
        .onFailure((e) {
          Get.snackbar('Error', e.message, backgroundColor: Colors.red, colorText: Colors.white);
        });
  }

  Future<void> _deleteLocation() async {
    if (widget.locationId == null) return;
    
    Get.back(); // Close dialog
    setState(() => _isLoading = true);
    
    final result = await _service.deleteLocation(widget.locationId!);
    
    setState(() => _isLoading = false);
    
    result
        .onSuccess((message) {
          Get.snackbar('Success', message, backgroundColor: Colors.green, colorText: Colors.white);
          // Refresh locations list
          final controller = Get.find<MerchantOnboardingController>();
          controller.fetchLocations();
          Get.back();
          Get.back(); // Go back to locations list
        })
        .onFailure((e) {
          Get.snackbar('Error', e.message, backgroundColor: Colors.red, colorText: Colors.white);
        });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _branchAddressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: '',
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Get.dialog(_deleteBranchDialog());
              },
              child: Image.asset(Assets.imagesTrash, height: 20),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: kSecondaryColor))
          : ListView(
              shrinkWrap: true,
              padding: AppSizes.DEFAULT,
              physics: BouncingScrollPhysics(),
              children: [
                MyText(
                  text: "Edit Location",
                  paddingTop: 8,
                  size: 24,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text: "Edit location details with address, coordinates, and contact information.",
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 30,
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
                  hintText: _state.isEmpty ? 'Enter state' : _state,
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
                  hintText: _country.isEmpty ? 'Enter country' : _country,
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
                  hintText: _latitude?.toString() ?? 'Enter latitude',
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
                  hintText: _longitude?.toString() ?? 'Enter longitude',
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
                  items: ['main', 'franchise'],
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
          buttonText: 'Save Details',
          onTap: _saveLocation,
        ),
      ),
    );
  }

  Column _deleteBranchDialog() {
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
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Image.asset(Assets.imagesCloseIcon, height: 14),
                      ),
                    ),
                  ],
                ),
                MyText(
                  paddingTop: 16,
                  text: 'Delete Location?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text: 'Are you sure you want to remove this location? This action cannot be undone.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                MyButton(
                  height: 42,
                  buttonText: 'Delete Location',
                  onTap: _deleteLocation,
                ),
                SizedBox(height: 12),
                MyBorderButton(
                  borderColor: kGreyColor2,
                  height: 42,
                  buttonText: 'Cancel',
                  onTap: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
