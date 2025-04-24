import 'package:base_code/app/config/text_styles.dart';
import 'package:flutter/material.dart';

class CustomRadioSetting<T> extends StatelessWidget {
  const CustomRadioSetting(
      {super.key,
      required this.title,
      required this.value,
      this.groupValue,
      this.onChanged});

  final String title;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      title: Text(title, style: TextStyles.medium),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
