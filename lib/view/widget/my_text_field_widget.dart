import 'package:flutter/material.dart';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/view/widget/my_text_widget.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  MyTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.isObSecure = false,
    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.labelSize,
    this.prefix,
    this.suffix,
    this.isReadOnly,
    this.onTap,
    this.isMandatory = false,
    this.keyboardType,
    this.autocorrect = true,
  }) : super(key: key);

  String? labelText, hintText;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;
  bool? isObSecure, isReadOnly;
  double? marginBottom;
  int? maxLines;
  double? labelSize;
  Widget? prefix, suffix;
  final VoidCallback? onTap;
  final bool isMandatory;
  final TextInputType? keyboardType;
  final bool autocorrect;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.marginBottom!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.labelText != null)
            Row(
              children: [
                MyText(
                  text: widget.labelText ?? '',
                  paddingBottom: 6,
                  size: 14,
                  weight: FontWeight.w600,
                ),
                // if (widget.isMandatory)
                //   MyText(
                //     paddingLeft: 2,
                //     paddingBottom: 6,
                //     text: '*',
                //     size: 12,
                //     color: Color(0xffFF3B30),
                //     weight: FontWeight.bold,
                //   ),
              ],
            ),
          Focus(
            onFocusChange: (focus) {
              setState(() {
                isFocused = focus;
              });
            },
            child: TextFormField(
              onTap: widget.onTap,
              textAlignVertical:
                  widget.prefix != null || widget.suffix != null
                      ? TextAlignVertical.center
                      : null,
              cursorColor: kQuaternaryColor,
              maxLines: widget.maxLines,
              readOnly: widget.isReadOnly ?? false,
              controller: widget.controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.next,
              keyboardType: widget.keyboardType,
              autocorrect: widget.autocorrect,
              obscureText: widget.isObSecure!,
              obscuringCharacter: '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kQuaternaryColor,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffFCFCFC),
                prefixIcon: widget.prefix,
                suffixIcon: widget.suffix,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: widget.maxLines! > 1 ? 15 : 0,
                ),
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: kQuaternaryColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kBorderColor, width: 1),
                  borderRadius: BorderRadius.circular(
                    widget.maxLines != null && widget.maxLines! > 1 ? 20 : 50,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: kTertiaryColor, width: 1),
                  borderRadius: BorderRadius.circular(
                    widget.maxLines != null && widget.maxLines! > 1 ? 20 : 50,
                  ),
                ),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
