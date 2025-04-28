import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.onTap,
    required this.iconUrl,
    this.colorBG,
    this.colorIcon,
  });

  final VoidCallback? onTap;
  final IconData iconUrl;
  final Color? colorBG;
  final Color? colorIcon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        style: ButtonStyle(
            fixedSize: const WidgetStatePropertyAll(Size(50, 50)),
            shape: const WidgetStatePropertyAll(CircleBorder()),
            backgroundColor: WidgetStatePropertyAll(colorBG ?? Colors.white)),
        onPressed: onTap,
        icon: Icon(iconUrl, color: colorIcon ?? Colors.black));
  }
}
