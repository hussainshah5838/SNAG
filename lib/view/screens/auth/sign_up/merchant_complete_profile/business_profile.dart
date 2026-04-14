import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

/// BusinessProfile exposes a GlobalKey so CompleteProfile can
/// call submit() on the Next button tap — same pattern as a Form key.
class BusinessProfile extends StatefulWidget {
  const BusinessProfile({super.key});

  @override
  BusinessProfileState createState() => BusinessProfileState();
}

class BusinessProfileState extends State<BusinessProfile> {
  final _branchNameController  = TextEditingController();
  final _phoneController       = TextEditingController();
  final _addressController     = TextEditingController();

  String? _selectedIndustry;
  final List<String> _selectedSubCategories = [];
  File? _logoFile;

  final _industryCtrl = IndustryController.instance;

  @override
  void dispose() {
    _branchNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _logoFile = File(picked.path));
  }

  /// Called by CompleteProfile's Next button.
  /// Returns the form data if valid, null if validation fails.
  Map<String, dynamic>? getFormData() {
    print('DEBUG branchName: "${_branchNameController.text.trim()}"');
    print('DEBUG phone: "${_phoneController.text.trim()}"');
    print('DEBUG address: "${_addressController.text.trim()}"');
    print('DEBUG industry: $_selectedIndustry');
    print('DEBUG subCategories: $_selectedSubCategories');

    if (_branchNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _selectedIndustry == null ||
        _selectedSubCategories.isEmpty) {
      return null; // CompleteProfile will show the error
    }

    return {
      'branchName':    _branchNameController.text.trim(),
      'phoneNumber':   _phoneController.text.trim(),
      'branchAddress': _addressController.text.trim(),
      'industry':      _selectedIndustry!,
      'subCategories': List<String>.from(_selectedSubCategories),
      'logoFile':      _logoFile,
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
          text: 'Business Profile',
          paddingTop: 8,
          size: 24,
          weight: FontWeight.w600,
          paddingBottom: 8,
        ),
        MyText(
          text: "Manage your company's info, logo, contact details, and settings.",
          size: 16,
          lineHeight: 1.5,
          weight: FontWeight.w500,
          color: kQuaternaryColor,
          paddingBottom: 30,
        ),
        MyTextField(
          controller: _branchNameController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesCompany, height: 20)],
          ),
          labelText: 'Company Name',
          hintText: 'StarBaksh',
          isMandatory: true,
        ),
        MyTextField(
          controller: _phoneController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesPhone, height: 20)],
          ),
          labelText: 'Phone Number',
          hintText: '+971 0432323332',
          isMandatory: true,
        ),
        MyTextField(
          controller: _addressController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesLoc, height: 20)],
          ),
          labelText: 'Company Address',
          hintText: '12 street, Block B, Sydney, Australia',
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
          isReadOnly: true,
          onTap: _pickLogo,
          labelText: 'Upload Logo',
          hintText: _logoFile != null ? _logoFile!.path.split('/').last : 'logo.png',
          isMandatory: true,
        ),
        // Only industry dropdown uses Obx — keeps GlobalKey state intact
        Obx(() {
          final industries = _industryCtrl.industries;
          if (industries.isEmpty) {
            return Center(child: CircularProgressIndicator(color: kSecondaryColor));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomDropDown(
                prefix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(Assets.imagesFood, height: 20)],
                ),
                labelText: 'Industry',
                hint: 'Select Industry',
                isMandatory: true,
                items: ['Select Industry', ...industries.toList()],
                selectedValue: _selectedIndustry ?? 'Select Industry',
                onChanged: (val) => setState(() {
                  _selectedIndustry = val == 'Select Industry' ? null : val;
                  _selectedSubCategories.clear();
                }),
              ),
              MultiDropDown(
                prefix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(Assets.imagesGps, height: 20)],
                ),
                labelText: 'Sub Category',
                hint: 'Select Sub Category',
                isMandatory: true,
                items: industries.toList(),
                selectedValues: _selectedSubCategories,
                onTap: (val) => setState(() {
                  _selectedSubCategories.contains(val)
                      ? _selectedSubCategories.remove(val)
                      : _selectedSubCategories.add(val);
                }),
              ),
            ],
          );
        }),
      ],
    );
  }
}
