import 'package:base_code/app/config/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.targetFocusNode,
    required this.label,
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
    this.leadingIcon,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? targetFocusNode;
  final String label;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? leadingIcon;
  final bool isPassword;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool? isShowPass;

  @override
  void initState() {
    if (widget.isPassword) isShowPass = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          onChanged: widget.onChanged,
          obscureText: widget.isPassword ? (!isShowPass!) : false,
          decoration: InputDecoration(
            labelText: widget.label,
            prefixIcon: widget.leadingIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isShowPass = !isShowPass!;
                      });
                    },
                    icon: Icon(
                      isShowPass! ? Icons.visibility : Icons.visibility_off,
                      color: AppColor.colorWelcome,
                    ),
                  )
                : null,
          ),
          onFieldSubmitted: widget.onFieldSubmitted ??
              (_) =>
                  FocusScope.of(context).requestFocus(widget.targetFocusNode),
          validator: widget.validator,
        ),
      ],
    );
  }
}
