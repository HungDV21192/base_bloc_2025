import 'package:base_code/stringee_call/widget/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:stringee_plugin/stringee_plugin.dart';

class GetBtnAudio extends StatelessWidget {
  const GetBtnAudio({super.key, required this.audioDevice, this.toggleSpeaker});

  final AudioDevice audioDevice;
  final VoidCallback? toggleSpeaker;

  @override
  Widget build(BuildContext context) {
    IconData? icon = Icons.volume_down;
    Color? color = Colors.black;
    Color? primary = Colors.white;
    switch (audioDevice.audioType) {
      case AudioType.speakerPhone:
        icon = Icons.volume_up;
        color = Colors.white;
        primary = Colors.white54;
        break;
      case AudioType.wiredHeadset:
        icon = Icons.headphones;
        color = Colors.black;
        primary = Colors.white;
        break;
      case AudioType.earpiece:
        icon = Icons.volume_down;
        color = Colors.black;
        primary = Colors.white;
        break;
      case AudioType.bluetooth:
        icon = Icons.bluetooth;
        color = Colors.black;
        primary = Colors.white;
        break;
      case AudioType.other:
        break;
      case AudioType.none:
        break;
    }
    return CircleButton(
      colorBG: primary,
      onTap: toggleSpeaker,
      iconUrl: icon,
      colorIcon: color,
    );
  }
}
