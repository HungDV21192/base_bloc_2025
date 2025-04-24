import 'package:base_code/app/config/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.bgColor,
    this.onTap,
    this.isLoading = false,
    required this.label,
  });

  final Color? bgColor;
  final VoidCallback? onTap;
  final bool isLoading;

  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
                onTap != null ? Colors.red : Colors.grey)),
        onPressed: onTap,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: (isLoading == true)
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  label,
                  style: TextStyles.medium,
                  textAlign: TextAlign.center,
                ),
        ));
  }
}
