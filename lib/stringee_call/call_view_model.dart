import 'dart:io';

import 'package:base_code/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stringee_plugin/stringee_plugin.dart';

class CallViewModel with ChangeNotifier {
  final StringeeClient client;
  final bool showIncomingUi;
  final String toUserId;
  final String fromUserId;
  final StringeeObjectEventType callType;
  final bool isVideoCall;
  final StringeeCall? call;
  final StringeeCall2? call2;

  CallViewModel({
    required this.client,
    required this.showIncomingUi,
    required this.toUserId,
    required this.fromUserId,
    required this.callType,
    required this.isVideoCall,
    this.call,
    this.call2,
  });

  late StringeeAudioManager _audioManager;
  var _showIncomingUi = false;

  bool get getShowIncomingUi => _showIncomingUi;
  StringeeCall2? stringeeCall2;
  StringeeCall? stringeeCall;
  String status = "";
  bool _isMute = false;

  bool get isMute => _isMute;
  bool _isVideoEnable = false;

  bool get isVideoEnable => _isVideoEnable;
  Widget? localScreen;
  Widget? remoteScreen;
  bool _initializingAudio = true;
  AudioDevice _audioDevice = AudioDevice(audioType: AudioType.earpiece);

  AudioDevice get audioDevice => _audioDevice;
  List<AudioDevice> _availableAudioDevices = [];
  StringeeAudioEvent? _event;

  void onInit() {
    _showIncomingUi = showIncomingUi;
    _audioManager = StringeeAudioManager();
    _isVideoEnable = isVideoCall;
    stringeeCall = call;
    stringeeCall2 = call2;
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
          } else if (isVideoCall) {
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
    if (callType == StringeeObjectEventType.call) {
      makeOrInitAnswerCall();
    } else {
      makeOrInitAnswerCall2();
    }
  }

  void changeAudioDevice(AudioDevice device) {
    _audioManager.selectDevice(device).then((value) {
      if (value.status) {
        _audioDevice = device;
        notifyListeners();
      }
    });
  }

  Future makeOrInitAnswerCall() async {
    if (!_showIncomingUi) {
      stringeeCall = StringeeCall(client);
    }

    if (stringeeCall != null) {
      stringeeCall!.eventStreamController.stream.listen((event) {
        Map<dynamic, dynamic> map = event;
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
            break;
        }
      });
    }

    if (_showIncomingUi) {
      if (stringeeCall != null) {
        stringeeCall!.initAnswer().then((event) {
          bool status = event['status'];
          if (!status) {
            clearDataEndDismiss();
          }
        });
      }
    } else {
      final parameters = {
        'from': fromUserId,
        'to': toUserId,
        'isVideoCall': isVideoCall,
        'customData': null,
        'videoQuality': VideoQuality.fullHd,
      };
      if (stringeeCall != null) {
        stringeeCall!.makeCall(parameters).then((result) {
          bool status = result['status'];
          int code = result['code'];
          String message = result['message'];
          if (!status) {
            Navigator.pop(navigatorKey.currentContext!);
          }
        });
      }
    }
  }

  void handleSignalingStateChangeEvent(StringeeSignalingState state) {
    status = state.toString().split('.')[1];
    notifyListeners();
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

  Future makeOrInitAnswerCall2() async {
    if (!_showIncomingUi) {
      stringeeCall2 = StringeeCall2(client);
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
        'from': fromUserId,
        'to': toUserId,
        'isVideoCall': isVideoCall,
        'customData': null,
        'videoQuality': VideoQuality.fullHd,
      };

      stringeeCall2!.makeCall(parameters).then((result) {
        bool status = result['status'];
        int code = result['code'];
        String message = result['message'];
        if (!status) {
          Navigator.pop(navigatorKey.currentContext!);
        }
      });
    }
  }

  void endCallTapped() {
    if (callType == StringeeObjectEventType.call && stringeeCall != null) {
      stringeeCall!.hangup().then((result) {
        bool status = result['status'];
        print('check xem status la gi $status');
        if (status) {
          if (Platform.isAndroid) {
            clearDataEndDismiss();
          }
        }
      });
    } else if (callType == StringeeObjectEventType.call2 &&
        stringeeCall2 != null) {
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

  void acceptCallTapped() {
    _showIncomingUi = !_showIncomingUi;
    notifyListeners();
    if (callType == StringeeObjectEventType.call) {
      if (stringeeCall != null) {
        stringeeCall!.answer().then((result) {
          bool status = result['status'];
          if (!status) {
            clearDataEndDismiss();
          }
        });
      }
    } else if (callType == StringeeObjectEventType.call2) {
      if (stringeeCall2 != null) {
        stringeeCall2!.answer().then((result) {
          bool status = result['status'];
          if (!status) {
            clearDataEndDismiss();
          }
        });
      }
    }
  }

  void rejectCallTapped() {
    if (callType == StringeeObjectEventType.call) {
      if (stringeeCall != null) {
        stringeeCall!.reject().then((result) {
          if (Platform.isAndroid) {
            clearDataEndDismiss();
          }
        });
      }
    } else if (callType == StringeeObjectEventType.call2) {
      if (stringeeCall2 != null) {
        stringeeCall2!.reject().then((result) {
          if (Platform.isAndroid) {
            clearDataEndDismiss();
          }
        });
      }
    }
  }

  void handleMediaStateChangeEvent(StringeeMediaState state) {
    status = state.toString().split('.')[1];
    notifyListeners();
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
      localScreen = null;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 200), () {});
    }
    localScreen = new StringeeVideoView(
      callId,
      true,
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 25.0, right: 25.0),
      height: 150.0,
      width: 100.0,
      scalingType: ScalingType.fit,
    );
    notifyListeners();
  }

  void handleReceiveRemoteStreamEvent(String callId) {
    if (remoteScreen != null) {
      remoteScreen = null;
      notifyListeners();
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      remoteScreen = StringeeVideoView(
        callId,
        false,
        isMirror: false,
        scalingType: ScalingType.fit,
      );
      notifyListeners();
    });
  }

  void handleAddVideoTrackEvent(StringeeVideoTrack track) {
    if (track.isLocal) {
      localScreen = null;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 200), () {
        localScreen = track.attach(
          alignment: Alignment.topRight,
          margin: const EdgeInsets.only(top: 25.0, right: 25.0),
          height: 150.0,
          width: 100.0,
          scalingType: ScalingType.fit,
        );
      });
      notifyListeners();
    } else {
      remoteScreen = null;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 200), () {
        remoteScreen = track.attach(
          isMirror: false,
          scalingType: ScalingType.fit,
        );
      });
      notifyListeners();
    }
  }

  void handleRemoveVideoTrackEvent(StringeeVideoTrack track) {}

  void clearDataEndDismiss() {
    _audioManager.removeListener(_event!);
    _audioManager.stop();
    if (callType == StringeeObjectEventType.call) {
      if (stringeeCall != null) stringeeCall?.destroy();
      stringeeCall = null;
      Navigator.pop(navigatorKey.currentContext!);
    } else if (callType == StringeeObjectEventType.call2) {
      stringeeCall2!.destroy();
      stringeeCall2 = null;
      Navigator.pop(navigatorKey.currentContext!);
    } else {
      Navigator.pop(navigatorKey.currentContext!);
    }
  }

  void toggleSwitchCamera() {
    if (callType == StringeeObjectEventType.call) {
      stringeeCall?.switchCamera().then((result) {
        bool status = result['status'];
        if (status) {}
      });
    } else if (callType == StringeeObjectEventType.call2) {
      stringeeCall2!.switchCamera().then((result) {
        bool status = result['status'];
        if (status) {}
      });
    }
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
        context: navigatorKey.currentContext!,
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
    if (callType == StringeeObjectEventType.call) {
      if (stringeeCall != null) {
        stringeeCall!.mute(!_isMute).then((result) {
          bool status = result['status'];
          if (status) {
            _isMute = !_isMute;
            notifyListeners();
          }
        });
      }
    } else if (callType == StringeeObjectEventType.call2) {
      if (stringeeCall2 != null) {
        stringeeCall2!.mute(!_isMute).then((result) {
          bool status = result['status'];
          if (status) {
            _isMute = !_isMute;
            notifyListeners();
          }
        });
      }
    }
  }

  void toggleVideo() {
    if (callType == StringeeObjectEventType.call && stringeeCall != null) {
      stringeeCall!.enableVideo(!_isVideoEnable).then((result) {
        bool status = result['status'];
        if (status) {
          _isVideoEnable = !_isVideoEnable;
          notifyListeners();
        }
      });
    } else if (callType == StringeeObjectEventType.call2 &&
        stringeeCall2 != null) {
      stringeeCall2!.enableVideo(!_isVideoEnable).then((result) {
        bool status = result['status'];
        if (status) {
          _isVideoEnable = !_isVideoEnable;
          notifyListeners();
        }
      });
    }
  }
}
