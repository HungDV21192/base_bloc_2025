import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.targetFocusNode,
    required this.label,
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? targetFocusNode;
  final String label;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      onFieldSubmitted: onFieldSubmitted ??
          (_) => FocusScope.of(context).requestFocus(targetFocusNode),
      validator: validator,
    );
  }
}
