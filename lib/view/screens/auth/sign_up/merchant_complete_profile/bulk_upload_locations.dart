import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';

class BulkUploadLocations extends StatefulWidget {
  const BulkUploadLocations({super.key});

  @override
  BulkUploadLocationsState createState() => BulkUploadLocationsState();
}

class BulkUploadLocationsState extends State<BulkUploadLocations> {
  File? _csvFile;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() => _csvFile = File(result.files.single.path!));
    }
  }

  Map<String, dynamic>? getFormData() {
    if (_csvFile == null) {
      Get.snackbar('Error', 'Please upload a CSV file',
          backgroundColor: kRedColor, colorText: kPrimaryColor);
      return null;
    }
    return {
      'csvFile': _csvFile!,
      'notes':   _notesController.text.trim(),
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
          text: "Bulk Upload Locations",
          paddingTop: 8,
          size: 24,
          weight: FontWeight.w600,
          paddingBottom: 8,
        ),
        MyText(
          text: "Upload multiple Location at once with our CSV template.",
          size: 16,
          lineHeight: 1.5,
          weight: FontWeight.w500,
          color: kQuaternaryColor,
          paddingBottom: 30,
        ),
        if (_csvFile == null)
          GestureDetector(
            onTap: _pickFile,
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
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.imagesUploadIcon, height: 24),
                    MyText(
                      paddingTop: 8,
                      text: 'Drag & Drop or choose file to upload',
                      size: 14,
                      weight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                    MyText(
                      paddingTop: 2,
                      text: 'Supported formats : CSV',
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
        if (_csvFile != null)
          GestureDetector(
            onTap: _pickFile,
            child: Container(
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
                          text: _csvFile!.path.split('/').last,
                          size: 16,
                          weight: FontWeight.w600,
                          paddingBottom: 4,
                        ),
                        MyText(text: 'CSV File', size: 14, color: kQuaternaryColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: 20),
        MyTextField(
          controller: _notesController,
          prefix: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset(Assets.imagesTt, height: 20)],
          ),
          labelText: 'Additional Notes (Optional)',
          hintText: 'e.g., "These branches are in Lahore only"',
          onChanged: (val) {},
        ),
      ],
    );
  }
}
