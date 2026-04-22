import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/controllers/merchant_onboarding_controller.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class BulkLocationsUpload extends StatefulWidget {
  const BulkLocationsUpload({super.key});

  @override
  State<BulkLocationsUpload> createState() => _BulkLocationsUploadState();
}

class _BulkLocationsUploadState extends State<BulkLocationsUpload> {
  final _controller = Get.find<MerchantOnboardingController>();
  final _notesController = TextEditingController();
  
  File? _csvFile;
  String _fileName = "";
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickCsvFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _csvFile = File(result.files.single.path!);
          _fileName = result.files.single.name;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick file: $e', backgroundColor: kRedColor, colorText: kPrimaryColor);
    }
  }

  Future<void> _uploadCsv() async {
    if (_csvFile == null) {
      Get.snackbar('Error', 'Please select a CSV file', backgroundColor: kRedColor, colorText: kPrimaryColor);
      return;
    }

    setState(() => _isLoading = true);

    final success = await _controller.bulkUploadLocations(
      csvFile: _csvFile!,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      Get.snackbar('Success', 'Locations uploaded successfully', backgroundColor: Colors.green, colorText: Colors.white);
      _controller.fetchLocations(); // Refresh list
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
                  text: "Bulk Upload Locations",
                  paddingTop: 8,
                  size: 24,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text: "Upload multiple locations at once with our CSV template.",
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 30,
                ),
                
                // File picker area
                if (_csvFile == null)
                  GestureDetector(
                    onTap: _pickCsvFile,
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: kBorderColor,
                        strokeWidth: 1,
                        dashPattern: [4, 4],
                        strokeCap: StrokeCap.round,
                        radius: Radius.circular(10),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kFillColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Assets.imagesUploadIcon, height: 24),
                            MyText(
                              paddingTop: 8,
                              text: 'Tap to choose CSV file',
                              size: 14,
                              weight: FontWeight.w500,
                              textAlign: TextAlign.center,
                            ),
                            MyText(
                              paddingTop: 2,
                              text: 'Supported format: CSV',
                              size: 12,
                              color: kQuaternaryColor,
                              lineHeight: 1.6,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                // Show selected file
                if (_csvFile != null) ...[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kFillColor,
                      border: Border.all(color: kBorderColor, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        Image.asset(Assets.imagesFile, height: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText(
                                text: _fileName,
                                size: 16,
                                weight: FontWeight.w600,
                                paddingBottom: 4,
                              ),
                              MyText(text: 'CSV File', size: 14, color: kQuaternaryColor),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _csvFile = null;
                            _fileName = "";
                          }),
                          child: Icon(Icons.close, color: kRedColor, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
                
                SizedBox(height: 20),
                
                // Additional notes
                MyTextField(
                  controller: _notesController,
                  prefix: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.asset(Assets.imagesTt, height: 20)],
                  ),
                  labelText: 'Additional Notes (Optional)',
                  hintText: 'e.g., These branches are in Lahore only',
                  isMandatory: false,
                  onChanged: (val) {},
                ),
              ],
            ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(
          buttonText: 'Upload',
          onTap: _uploadCsv,
        ),
      ),
    );
  }
}
