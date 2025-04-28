import 'dart:io';

import 'package:base_code/stringee_call/widget/bottom_container.dart';
import 'package:base_code/stringee_call/widget/info_user_call.dart';
import 'package:base_code/stringee_call/widget/switch_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stringee_plugin/stringee_plugin.dart';

class CallScreen extends StatefulWidget {
  final StringeeClient client;
  final bool showIncomingUi;
  final String toUserId;
  final String fromUserId;
  final StringeeObjectEventType callType;
  final bool isVideoCall;

  const CallScreen({
    super.key,
    required this.client,
    this.showIncomingUi = false,
    required this.toUserId,
    required this.fromUserId,
    required this.callType,
    this.isVideoCall = false,
  });

  @override
  State<StatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late StringeeAudioManager _audioManager;
  var _showIncomingUi = false;
  StringeeCall2? stringeeCall2;
  StringeeCall? stringeeCall;
  String status = "";
  bool _isMute = false;
  bool _isVideoEnable = false;
  Widget? localScreen;
  Widget? remoteScreen;
  bool _initializingAudio = true;
  AudioDevice _audioDevice = AudioDevice(audioType: AudioType.earpiece);
  List<AudioDevice> _availableAudioDevices = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  StringeeAudioEvent? _event;

  void changeAudioDevice(AudioDevice device) {
    _audioManager.selectDevice(device).then((value) {
      if (value.status) {
        setState(() {
          _audioDevice = device;
        });
      }
    });
  }

  Future makeOrInitAnswerCall() async {
    if (!_showIncomingUi) {
      stringeeCall = StringeeCall(widget.client);
    }

    stringeeCall!.eventStreamController.stream.listen((event) {
      Map<dynamic, dynamic> map = event;
      print('check data map \n${map.toString()}');
      switch (map['eventType']) {
        case StringeeCallEvents.didChangeSignalingState:
          handleSignalingStateChangeEvent(map['body']);
          break;
        case StringeeCallEvents.didChangeMediaState:
          handleMediaStateChangeEvent(map['body']);
          break;
        case StringeeCallEvents.didReceiveCallInfo:
          handleReceiveCallInfoEvent(map['body']);
          break;
        case StringeeCallEvents.didHandleOnAnotherDevice:
          handleHandleOnAnotherDeviceEvent(map['body']);
          break;
        case StringeeCallEvents.didReceiveLocalStream:
          handleReceiveLocalStreamEvent(map['body']);
          break;
        case StringeeCallEvents.didReceiveRemoteStream:
          handleReceiveRemoteStreamEvent(map['body']);
          break;
        default:
          print('dsa');
          break;
      }
    });

    if (_showIncomingUi) {
      stringeeCall!.initAnswer().then((event) {
        bool status = event['status'];
        if (!status) {
          clearDataEndDismiss();
        }
      });
    } else {
      final parameters = {
        'from': widget.fromUserId,
        'to': widget.toUserId,
        'isVideoCall': widget.isVideoCall,
        'customData': null,
        'videoQuality': VideoQuality.fullHd,
      };
      print('check pparamete\n${parameters.toString()}');
      stringeeCall!.makeCall(parameters).then((result) {
        bool status = result['status'];
        int code = result['code'];
        String message = result['message'];
        if (!status) {
          Navigator.pop(context);
        }
      });
    }
  }

  void handleSignalingStateChangeEvent(StringeeSignalingState state) {
    setState(() {
      status = state.toString().split('.')[1];
    });
    switch (state) {
      case StringeeSignalingState.calling:
        break;
      case StringeeSignalingState.ringing:
        break;
      case StringeeSignalingState.answered:
        break;
      case StringeeSignalingState.busy:
        clearDataEndDismiss();
        break;
      case StringeeSignalingState.ended:
        clearDataEndDismiss();
        break;
      default:
        break;
    }
  }

  void handleMediaStateChangeEvent(StringeeMediaState state) {
    setState(() {
      status = state.toString().split('.')[1];
    });
  }

  void handleReceiveCallInfoEvent(Map<dynamic, dynamic> info) {}

  void handleHandleOnAnotherDeviceEvent(StringeeSignalingState state) {
    if (state == StringeeSignalingState.answered ||
        state == StringeeSignalingState.ended ||
        state == StringeeSignalingState.busy) {
      clearDataEndDismiss();
    }
  }

  void handleReceiveLocalStreamEvent(String callId) {
    if (localScreen != null) {
      setState(() {
        localScreen = null;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          localScreen = new StringeeVideoView(
            callId,
            true,
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 25.0, right: 25.0),
            height: 150.0,
            width: 100.0,
            scalingType: ScalingType.fit,
          );
        });
      });
    } else {
      setState(() {
        localScreen = new StringeeVideoView(
          callId,
          true,
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(top: 25.0, right: 25.0),
          height: 150.0,
          width: 100.0,
          scalingType: ScalingType.fit,
        );
      });
    }
  }

  void handleReceiveRemoteStreamEvent(String callId) {
    if (remoteScreen != null) {
      setState(() {
        remoteScreen = null;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          remoteScreen = new StringeeVideoView(
            callId,
            false,
            isMirror: false,
            scalingType: ScalingType.fit,
          );
        });
      });
    } else {
      setState(() {
        remoteScreen = new StringeeVideoView(
          callId,
          false,
          isMirror: false,
          scalingType: ScalingType.fit,
        );
      });
    }
  }

  void handleAddVideoTrackEvent(StringeeVideoTrack track) {
    if (track.isLocal) {
      setState(() {
        localScreen = null;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          localScreen = track.attach(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 25.0, right: 25.0),
            height: 150.0,
            width: 100.0,
            scalingType: ScalingType.fit,
          );
        });
      });
    } else {
      setState(() {
        remoteScreen = null;
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          remoteScreen = track.attach(
            isMirror: false,
            scalingType: ScalingType.fit,
          );
        });
      });
    }
  }

  void handleRemoveVideoTrackEvent(StringeeVideoTrack track) {}

  Future makeOrInitAnswerCall2() async {
    if (!_showIncomingUi) {
      stringeeCall2 = StringeeCall2(widget.client);
    }
    stringeeCall2!.eventStreamController.stream.listen((event) {
      Map<dynamic, dynamic> map = event;
      switch (map['eventType']) {
        case StringeeCall2Events.didChangeSignalingState:
          handleSignalingStateChangeEvent(map['body']);
          break;
        case StringeeCall2Events.didChangeMediaState:
          handleMediaStateChangeEvent(map['body']);
          break;
        case StringeeCall2Events.didReceiveCallInfo:
          handleReceiveCallInfoEvent(map['body']);
          break;
        case StringeeCall2Events.didHandleOnAnotherDevice:
          handleHandleOnAnotherDeviceEvent(map['body']);
          break;
        case StringeeCall2Events.didReceiveLocalStream:
          handleReceiveLocalStreamEvent(map['body']);
          break;
        case StringeeCall2Events.didReceiveRemoteStream:
          handleReceiveRemoteStreamEvent(map['body']);
          break;
        case StringeeCall2Events.didAddVideoTrack:
          handleAddVideoTrackEvent(map['body']);
          break;
        case StringeeCall2Events.didRemoveVideoTrack:
          handleRemoveVideoTrackEvent(map['body']);
          break;
        default:
          break;
      }
    });

    if (_showIncomingUi) {
      stringeeCall2!.initAnswer().then((event) {
        bool status = event['status'];
        if (!status) {
          clearDataEndDismiss();
        }
      });
    } else {
      final parameters = {
        'from': widget.fromUserId,
        'to': widget.toUserId,
        'isVideoCall': widget.isVideoCall,
        'customData': null,
        'videoQuality': VideoQuality.fullHd,
      };

      stringeeCall2!.makeCall(parameters).then((result) {
        bool status = result['status'];
        int code = result['code'];
        String message = result['message'];
        if (!status) {
          Navigator.pop(context);
        }
      });
    }
  }

  void clearDataEndDismiss() {
    _audioManager.removeListener(_event!);
    _audioManager.stop();
    if (widget.callType == StringeeObjectEventType.call) {
      stringeeCall!.destroy();
      stringeeCall = null;
      Navigator.pop(context);
    } else if (widget.callType == StringeeObjectEventType.call2) {
      stringeeCall2!.destroy();
      stringeeCall2 = null;
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  void toggleSwitchCamera() {
    if (widget.callType == StringeeObjectEventType.call) {
      stringeeCall!.switchCamera().then((result) {
        bool status = result['status'];
        if (status) {}
      });
    } else if (widget.callType == StringeeObjectEventType.call2) {
      stringeeCall2!.switchCamera().then((result) {
        bool status = result['status'];
        if (status) {}
      });
    }
  }

  void acceptCallTapped() {
    if (widget.callType == StringeeObjectEventType.call) {
      stringeeCall!.answer().then((result) {
        bool status = result['status'];
        if (!status) {
          clearDataEndDismiss();
        }
      });
    } else if (widget.callType == StringeeObjectEventType.call2) {
      stringeeCall2!.answer().then((result) {
        bool status = result['status'];
        if (!status) {
          clearDataEndDismiss();
        }
      });
    }
    setState(() {
      _showIncomingUi = !_showIncomingUi;
    });
  }

  void toggleSpeaker() {
    if (_availableAudioDevices.length < 3) {
      if (_availableAudioDevices.length <= 1) {
        return;
      }
      int position = _availableAudioDevices.indexOf(_audioDevice);
      if (position == _availableAudioDevices.length - 1) {
        changeAudioDevice(_availableAudioDevices[0]);
      } else {
        changeAudioDevice(_availableAudioDevices[position + 1]);
      }
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.separated(
            itemCount: _availableAudioDevices.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_availableAudioDevices[index].name!),
                onTap: () {
                  changeAudioDevice(_availableAudioDevices[index]);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      );
    }
  }

  void toggleMicro() {
    if (widget.callType == StringeeObjectEventType.call) {
      stringeeCall!.mute(!_isMute).then((result) {
        bool status = result['status'];
        if (status) {
          setState(() {
            _isMute = !_isMute;
          });
        }
      });
    } else if (widget.callType == StringeeObjectEventType.call2) {
      stringeeCall2!.mute(!_isMute).then((result) {
        bool status = result['status'];
        if (status) {
          setState(() {
            _isMute = !_isMute;
          });
        }
      });
    }
  }

  void toggleVideo() {
    if (widget.callType == StringeeObjectEventType.call) {
      stringeeCall!.enableVideo(!_isVideoEnable).then((result) {
        bool status = result['status'];
        if (status) {
          setState(() {
            _isVideoEnable = !_isVideoEnable;
          });
        }
      });
    } else if (widget.callType == StringeeObjectEventType.call2) {
      stringeeCall2!.enableVideo(!_isVideoEnable).then((result) {
        bool status = result['status'];
        if (status) {
          setState(() {
            _isVideoEnable = !_isVideoEnable;
          });
        }
      });
    }
  }

  void rejectCallTapped() {
    if (widget.callType == StringeeObjectEventType.call) {
      stringeeCall!.reject().then((result) {
        if (Platform.isAndroid) {
          clearDataEndDismiss();
        }
      });
    } else if (widget.callType == StringeeObjectEventType.call2) {
      stringeeCall2!.reject().then((result) {
        if (Platform.isAndroid) {
          clearDataEndDismiss();
        }
      });
    }
  }

  void endCallTapped() {
    if (widget.callType == StringeeObjectEventType.call) {
      stringeeCall!.hangup().then((result) {
        bool status = result['status'];
        if (status) {
          if (Platform.isAndroid) {
            clearDataEndDismiss();
          }
        }
      });
    } else if (widget.callType == StringeeObjectEventType.call2) {
      stringeeCall2!.hangup().then((result) {
        bool status = result['status'];
        if (status) {
          if (Platform.isAndroid) {
            clearDataEndDismiss();
          }
        }
      });
    }
  }

  @override
  void initState() {
    print('check info clien\n${widget.client.toString()}');
    _showIncomingUi = widget.showIncomingUi;
    _audioManager = StringeeAudioManager();
    _isVideoEnable = widget.isVideoCall;
    _event = StringeeAudioEvent(
      onChangeAudioDevice: (selectedAudioDevice, availableAudioDevices) {
        _availableAudioDevices = availableAudioDevices;
        if (_initializingAudio) {
          _initializingAudio = false;
          int bluetoothIndex = -1;
          int wiredHeadsetIndex = -1;
          int speakerIndex = -1;
          int earpieceIndex = -1;
          for (var element in availableAudioDevices) {
            if (element.audioType == AudioType.bluetooth) {
              bluetoothIndex = availableAudioDevices.indexOf(element);
            }
            if (element.audioType == AudioType.wiredHeadset) {
              wiredHeadsetIndex = availableAudioDevices.indexOf(element);
            }
            if (element.audioType == AudioType.speakerPhone) {
              speakerIndex = availableAudioDevices.indexOf(element);
            }
            if (element.audioType == AudioType.earpiece) {
              earpieceIndex = availableAudioDevices.indexOf(element);
            }
          }
          if (bluetoothIndex != -1) {
            selectedAudioDevice =
                availableAudioDevices.elementAt(bluetoothIndex);
          } else if (wiredHeadsetIndex != -1) {
            selectedAudioDevice =
                availableAudioDevices.elementAt(wiredHeadsetIndex);
          } else if (widget.isVideoCall) {
            if (speakerIndex != -1) {
              selectedAudioDevice =
                  availableAudioDevices.elementAt(speakerIndex);
            }
          } else {
            if (earpieceIndex != -1) {
              selectedAudioDevice =
                  availableAudioDevices.elementAt(earpieceIndex);
            }
          }
        }
        changeAudioDevice(selectedAudioDevice);
      },
    );
    _audioManager.addListener(_event!);
    _audioManager.start();
    if (widget.callType == StringeeObjectEventType.call) {
      makeOrInitAnswerCall();
    } else {
      makeOrInitAnswerCall2();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('check remote screen1 $remoteScreen');
    print('check remote screen2 $localScreen');
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            remoteScreen != null
                ? remoteScreen!
                : const Placeholder(
                    color: Colors.transparent,
                  ),
            localScreen != null
                ? localScreen!
                : const Placeholder(
                    color: Colors.transparent,
                  ),
            InfoUserCall(
                callerName: widget.toUserId, status: widget.fromUserId),
            BottomContainer(
              showIncomingUi: _showIncomingUi,
              rejectCallTapped: () => rejectCallTapped(),
              acceptCallTapped: () => acceptCallTapped(),
              toggleMicro: () => toggleMicro(),
              toggleVideo: () => toggleVideo(),
              endCallTapped: () => endCallTapped(),
              isMute: _isMute,
              isVideoEnable: _isVideoEnable,
            ),
            SwitchCamera(
              toggleSwitchCamera: () => toggleSwitchCamera(),
            ),
          ],
        ),
      ),
    );
  }
}
