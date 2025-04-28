import 'package:base_code/stringee_call/widget/circle_button.dart';
import 'package:flutter/material.dart';

class SwitchCamera extends StatelessWidget {
  const SwitchCamera({super.key, this.toggleSwitchCamera});

  final VoidCallback? toggleSwitchCamera;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 25.0),
        child:
            CircleButton(iconUrl: Icons.autorenew, onTap: toggleSwitchCamera),
      ),
    );
  }
}
