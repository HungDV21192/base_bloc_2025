import 'package:base_code/stringee_call/call_view_model.dart';
import 'package:base_code/stringee_call/widget/bottom_container.dart';
import 'package:base_code/stringee_call/widget/info_user_call.dart';
import 'package:base_code/stringee_call/widget/switch_camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stringee_plugin/stringee_plugin.dart';

class CallScreen extends StatelessWidget {
  final StringeeClient client;
  final bool showIncomingUi;
  final String toUserId;
  final String fromUserId;
  final StringeeObjectEventType callType;
  final bool isVideoCall;
  final StringeeCall2? stringeeCall2;
  final StringeeCall? stringeeCall;

  const CallScreen({
    super.key,
    required this.client,
    this.showIncomingUi = false,
    required this.toUserId,
    required this.fromUserId,
    required this.callType,
    this.isVideoCall = false,
    this.stringeeCall2,
    this.stringeeCall,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CallViewModel(
              client: client,
              showIncomingUi: showIncomingUi,
              toUserId: toUserId,
              fromUserId: fromUserId,
              callType: callType,
              isVideoCall: isVideoCall,
            ),
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<CallViewModel>(context, listen: false).onInit();
          });
          return Scaffold(
            backgroundColor: Colors.black,
            body: Consumer<CallViewModel>(
              builder: (context, provider, child) {
                return SafeArea(
                  child: Stack(
                    children: <Widget>[
                      provider.remoteScreen != null
                          ? provider.remoteScreen!
                          : const Placeholder(color: Colors.transparent),
                      provider.localScreen != null
                          ? provider.localScreen!
                          : const Placeholder(color: Colors.transparent),
                      InfoUserCall(
                          callerName: '$fromUserId -> $toUserId',
                          status: provider.status),
                      BottomContainer(
                        showIncomingUi: provider.getShowIncomingUi,
                        rejectCallTapped: () => provider.rejectCallTapped(),
                        acceptCallTapped: () => provider.acceptCallTapped(),
                        toggleMicro: () => provider.toggleMicro(),
                        toggleVideo: () => provider.toggleVideo(),
                        endCallTapped: () => provider.endCallTapped(),
                        toggleSpeaker: () => provider.toggleSpeaker(),
                        isMute: provider.isMute,
                        isVideoEnable: provider.isVideoEnable,
                        audioDevice: provider.audioDevice,
                      ),
                      if (provider.isVideoEnable)
                        SwitchCamera(
                          toggleSwitchCamera: () =>
                              provider.toggleSwitchCamera(),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}
