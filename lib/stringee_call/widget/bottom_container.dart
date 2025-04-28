import 'package:base_code/stringee_call/widget/circle_button.dart';
import 'package:base_code/stringee_call/widget/get_btn_audio.dart';
import 'package:flutter/material.dart';
import 'package:stringee_plugin/stringee_plugin.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({
    super.key,
    this.showIncomingUi = false,
    this.rejectCallTapped,
    this.acceptCallTapped,
    this.toggleMicro,
    this.toggleVideo,
    this.endCallTapped,
    this.isMute = true,
    this.isVideoEnable = true,
    this.toggleSpeaker,
  });

  final bool showIncomingUi;
  final VoidCallback? rejectCallTapped;
  final VoidCallback? acceptCallTapped;
  final VoidCallback? toggleMicro;
  final VoidCallback? toggleVideo;
  final VoidCallback? endCallTapped;
  final bool isMute;
  final bool isVideoEnable;
  final VoidCallback? toggleSpeaker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30.0),
      alignment: Alignment.bottomCenter,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: showIncomingUi
              ? <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleButton(
                        onTap: rejectCallTapped,
                        iconUrl: Icons.call_end,
                        colorIcon: Colors.black,
                        colorBG: Colors.white,
                      ),
                      CircleButton(
                        colorBG: Colors.white,
                        onTap: acceptCallTapped,
                        iconUrl: Icons.call,
                        colorIcon: Colors.black,
                      ),
                    ],
                  )
                ]
              : <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GetBtnAudio(
                        audioDevice: AudioDevice(audioType: AudioType.earpiece),
                        toggleSpeaker: toggleSpeaker,
                      ),
                      CircleButton(
                        colorBG: isMute ? Colors.white : Colors.white54,
                        onTap: toggleMicro,
                        iconUrl: isMute ? Icons.mic : Icons.mic_off,
                        colorIcon: isMute ? Colors.black : Colors.white,
                      ),
                      CircleButton(
                        colorBG: isVideoEnable ? Colors.white54 : Colors.white,
                        onTap: toggleVideo,
                        iconUrl:
                            isVideoEnable ? Icons.videocam_off : Icons.videocam,
                        colorIcon: isVideoEnable ? Colors.white : Colors.black,
                      ),
                      CircleButton(
                        colorBG: Colors.red,
                        onTap: endCallTapped,
                        iconUrl: Icons.call_end,
                        colorIcon: Colors.white,
                      ),
                    ],
                  ),
                ]),
    );
  }
}
