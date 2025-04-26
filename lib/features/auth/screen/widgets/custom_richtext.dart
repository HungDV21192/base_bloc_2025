import 'package:base_code/app/config/app_color.dart';
import 'package:base_code/app/config/text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onTap});

  final String title;
  final String subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(text: title, style: TextStyles.medium, children: [
        TextSpan(
          text: subTitle,
          style: TextStyles.medium.copyWith(color: AppColor.colorMain),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ]),
    );
    ;
  }
}
