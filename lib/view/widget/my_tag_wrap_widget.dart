import 'package:flutter/material.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/view/widget/my_text_widget.dart';

class MyTagWrap extends StatelessWidget {
  final List<String> tags;
  final String title;

  const MyTagWrap({Key? key, required this.tags, required this.title})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MyText(
            text: title,
            size: 18,
            weight: FontWeight.w600,
            paddingBottom: 16,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                tags
                    .map(
                      (tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: MyText(
                          text: tag,
                          size: 12,
                          color: kPrimaryColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
