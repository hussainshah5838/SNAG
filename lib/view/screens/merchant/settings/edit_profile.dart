import 'dart:io';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_profile_controller.dart';
import 'package:snag/controllers/industry_controller.dart';
import 'package:snag/main.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/custom_check_box_widget.dart';
import 'package:snag/view/widget/custom_drop_down_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _profileController = Get.find<MerchantProfileController>();
  final _industryController = Get.put(IndustryController());
  final _imagePicker = ImagePicker();
  
  final _branchNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _subCategoryController = TextEditingController();
  
  String? _selectedIndustry;
  String _selectedRole = 'Owner/Admin';
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _industryController.fetchIndustries();
    _loadProfileData();
  }

  void _loadProfileData() {
    final profile = _profileController.branchProfile.value;
    if (profile != null) {
      _branchNameController.text = profile['branchName'] as String? ?? '';
      _phoneController.text = profile['phoneNumber'] as String? ?? '';
      _addressController.text = profile['branchAddress'] as String? ?? '';
      
      // Set industry from DB
      final industryFromApi = profile['industry'] as String?;
      if (industryFromApi != null) {
        _selectedIndustry = industryFromApi;
      }
      
      // Set role from DB
      final roleFromApi = profile['role'] as String?;
      if (roleFromApi != null) {
        _selectedRole = roleFromApi;
      }
      
      // Set subcategories from DB (join them as comma-separated)
      final subCats = (profile['subCategories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList();
      if (subCats != null && subCats.isNotEmpty) {
        _subCategoryController.text = subCats.join(', ');
      }
    }
  }

  Future<void> _saveProfile() async {
    print('🔵 [EDIT PROFILE] Saving profile...');
    print('🔵 Branch Name: ${_branchNameController.text.trim()}');
    print('🔵 Phone: ${_phoneController.text.trim()}');
    print('🔵 Address: ${_addressController.text.trim()}');
    print('🔵 Industry: $_selectedIndustry');
    print('🔵 Role: $_selectedRole');
    
    // Parse subcategories from comma-separated text
    final subCategoriesText = _subCategoryController.text.trim();
    final subCategories = subCategoriesText.isEmpty 
        ? <String>[]
        : subCategoriesText.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    
    print('🔵 SubCategories: $subCategories');
    
    if (_selectedIndustry == null) {
      Get.snackbar(
        'Error',
        'Please select an industry',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (subCategories.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter at least one subcategory',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    final success = await _profileController.updateBranchProfile(
      branchName: _branchNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      branchAddress: _addressController.text.trim(),
      industry: _selectedIndustry,
      subCategories: subCategories,
      role: _selectedRole,
      logoFile: _selectedImage, // Send selected image
    );

    if (success) {
      print('✅ [EDIT PROFILE] Profile updated successfully');
      Get.back();
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print('❌ [EDIT PROFILE] Error: ${_profileController.errorMsg.value}');
      Get.snackbar(
        'Error',
        _profileController.errorMsg.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    _branchNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        Get.back(); // Close modal
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        Get.back(); // Close modal
      }
    } catch (e) {
      print('Error taking photo: $e');
      Get.snackbar('Error', 'Failed to take photo');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: Obx(() {
        final isLoading = _profileController.isLoading.value;
        final logoUrl = _profileController.logoUrl;

        return ListView(
          shrinkWrap: true,
          padding: AppSizes.DEFAULT,
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Show selected image or existing logo
                  _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            _selectedImage!,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CommonImageView(
                          url: logoUrl ?? dummyImg,
                          height: 140,
                          width: 140,
                          radius: 100,
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    bottom: 5,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          isScrollControlled: true,
                          builder: (context) {
                            Widget imageRow({
                              required String asset,
                              required String title,
                              required VoidCallback onTap,
                            }) {
                              return GestureDetector(
                                onTap: onTap,
                                child: Row(
                                  children: [
                                    Image.asset(asset, height: 24),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: MyText(
                                        text: title,
                                        size: 16,
                                        weight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Container(
                              height: 240,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 35,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      Assets.imagesHandle,
                                      width: 40,
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        Assets.imagesCloseIcon,
                                        height: 14,
                                        color: Colors.transparent,
                                      ),
                                      MyText(
                                        text: 'Upload',
                                        size: 20,
                                        weight: FontWeight.w600,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Image.asset(
                                          Assets.imagesCloseIcon,
                                          height: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  imageRow(
                                    asset: Assets.imagesUploadFile,
                                    title: 'Upload From Files',
                                    onTap: () async {
                                      await _pickImageFromGallery();
                                    },
                                  ),
                                  SizedBox(height: 30),
                                  imageRow(
                                    asset: Assets.imagesGallery,
                                    title: 'Upload From Gallery',
                                    onTap: () async {
                                      await _pickImageFromGallery();
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  imageRow(
                                    asset: Assets.imagesTakePhoto,
                                    title: 'Take a Photo',
                                    onTap: () async {
                                      await _pickImageFromCamera();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Image.asset(Assets.imagesEdit, height: 28),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
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
            // Phone Number
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
            // Company Address
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
            // Industry - Dynamic dropdown from API
            Obx(() {
              final industries = _industryController.industries;
              final isLoading = _industryController.isLoading.value;
              
              if (isLoading || industries.isEmpty) {
                return MyTextField(
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesFood, height: 20)],
                  ),
                  labelText: 'Industry',
                  hintText: 'Loading industries...',
                  isReadOnly: true,
                  isMandatory: true,
                );
              }
              
              return CustomDropDown(
                prefix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(Assets.imagesFood, height: 20)],
                ),
                labelText: 'Industry',
                hint: 'Select Industry',
                isMandatory: true,
                items: industries,
                selectedValue: _selectedIndustry ?? industries.first,
                onChanged: (val) => setState(() => _selectedIndustry = val),
              );
            }),
            // Sub Categories - Free text field (comma-separated)
            MyTextField(
              controller: _subCategoryController,
              prefix: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesGps, height: 20)],
              ),
              labelText: 'Sub Categories',
              hintText: 'e.g. Fast Food, Coffee, Bakery',
              isMandatory: true,
            ),
            // Role
            CustomDropDown(
              prefix: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset(Assets.imagesName, height: 20)],
              ),
              labelText: 'Role',
              hint: 'Select Role',
              isMandatory: true,
              items: ['Owner/Admin', 'Manager', 'Staff', 'Other'],
              selectedValue: _selectedRole,
              onChanged: (val) => setState(() => _selectedRole = val),
            ),
          ],
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Obx(() {
            final isLoading = _profileController.isLoading.value;
            return MyButton(
              buttonText: isLoading ? 'Saving...' : 'Save Details',
              onTap: () {
                if (!isLoading) {
                  _saveProfile();
                }
              },
            );
          }),
        ),
      ),
    );
  }
}

class _DeleteDialog extends StatelessWidget {
  const _DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                  text: 'Delete your profile?',
                  size: 20,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'If you delete your profile, all your data and connections will be permanently removed. This can’t be undone.',
                  size: 15,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 24,
                ),
                ...List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        CustomCheckBox(
                          isRadio: true,
                          unSelectedColor: kSecondaryColor,
                          isActive: index == 0,
                          onTap: () {},
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: MyText(
                            text:
                                [
                                  "Everything’s fine — no issues",
                                  "They’re making me uncomfortable",
                                  "They’re being rude or abusive",
                                  "I’d like to report this chat",
                                ][index],
                            size: 15,
                            weight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 10),
                MyButton(
                  height: 42,
                  buttonText: 'Delete',
                  onTap: () {
                    Get.back();
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
}
