import 'package:dotted_border/dotted_border.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_button_widget.dart';
import 'package:snag/view/widget/my_text_field_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BulkLocationsUpload extends StatefulWidget {
  @override
  State<BulkLocationsUpload> createState() => _BulkLocationsUploadState();
}

class _BulkLocationsUploadState extends State<BulkLocationsUpload> {
  bool _showUploadedFile = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(title: ''),
      body: ListView(
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
          if (!_showUploadedFile)
            GestureDetector(
              onTap: () => setState(() => _showUploadedFile = true),
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
                        text: 'Supported formats : Jpeg, pdf',
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
          if (_showUploadedFile) ...[_UploadedFile()],
          SizedBox(height: 20),
          MyTextField(
            prefix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset(Assets.imagesTt, height: 20)],
            ),
            labelText: 'Additional Notes (Optional)',
            hintText: "e.g., “These branches are in Lahore only”",
            isMandatory: true,
            onChanged: (val) {},
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: AppSizes.DEFAULT,
        child: MyButton(buttonText: 'Add', onTap: () {}),
      ),
    );
  }
}

class _UploadedFile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  text: "Locations-template.csv",
                  size: 16,
                  weight: FontWeight.w600,
                  paddingBottom: 4,
                ),
                MyText(text: 'Csv File', size: 14, color: kQuaternaryColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
