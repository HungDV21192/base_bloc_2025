// import 'dart:io';
//
// import 'package:base_code/main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:stringee_plugin/stringee_plugin.dart';
//
// class CallViewModel with ChangeNotifier {
//   String status = "";
//   bool isMute = false;
//   bool isVideoEnable = false; // Biến quản lý việc ẩn hiện camera
//   Widget? localScreen;
//   Widget? remoteScreen;
//   bool _initializingAudio = true;
//   AudioDevice audioDevice = AudioDevice(audioType: AudioType.earpiece);
//   List<AudioDevice> _availableAudioDevices = [];
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   StringeeAudioEvent? _event;
//
//   //ToDo:
//
//   StringeeCall? stringCall;
//   StringeeCall2? stringCall2;
//   late StringeeAudioManager _audioManager;
//   var showIncomingUi = false;
//   late StringeeClient _client;
//   var fromUserId = '';
//   var toUserId = '';
//   var isVideoCall = false;
//   late StringeeObjectEventType callType;
//
//   void onInit(
//       {required StringeeClient client,
//       bool isShowIncomingUi = false,
//       required String toId,
//       required String fromID,
//       required StringeeObjectEventType type,
//       bool videoCall = false}) {
//     showIncomingUi = isShowIncomingUi;
//     callType = type;
//     fromUserId = fromID;
//     toUserId = toId;
//     isVideoCall = videoCall;
//     _client = client;
//     _audioManager = StringeeAudioManager();
//     isVideoEnable = isVideoCall;
//     //2ouf
//     // if (showIncomingUi) {
//     //   stringCall = StringeeCall(client);
//     //   stringCall2 = StringeeCall2(client);
//     // }
//     _event = StringeeAudioEvent(
//       onChangeAudioDevice: (selectedAudioDevice, availableAudioDevices) {
//         _availableAudioDevices = availableAudioDevices;
//         if (_initializingAudio) {
//           _initializingAudio = false;
//           int bluetoothIndex = -1;
//           int wiredHeadsetIndex = -1;
//           int speakerIndex = -1;
//           int earpieceIndex = -1;
//           for (var element in availableAudioDevices) {
//             if (element.audioType == AudioType.bluetooth) {
//               bluetoothIndex = availableAudioDevices.indexOf(element);
//             }
//             if (element.audioType == AudioType.wiredHeadset) {
//               wiredHeadsetIndex = availableAudioDevices.indexOf(element);
//             }
//             if (element.audioType == AudioType.speakerPhone) {
//               speakerIndex = availableAudioDevices.indexOf(element);
//             }
//             if (element.audioType == AudioType.earpiece) {
//               earpieceIndex = availableAudioDevices.indexOf(element);
//             }
//           }
//           if (bluetoothIndex != -1) {
//             selectedAudioDevice =
//                 availableAudioDevices.elementAt(bluetoothIndex);
//           } else if (wiredHeadsetIndex != -1) {
//             selectedAudioDevice =
//                 availableAudioDevices.elementAt(wiredHeadsetIndex);
//           } else if (isVideoCall) {
//             if (speakerIndex != -1) {
//               selectedAudioDevice =
//                   availableAudioDevices.elementAt(speakerIndex);
//             }
//           } else {
//             if (earpieceIndex != -1) {
//               selectedAudioDevice =
//                   availableAudioDevices.elementAt(earpieceIndex);
//             }
//           }
//         }
//         changeAudioDevice(selectedAudioDevice);
//       },
//     );
//     _audioManager.addListener(_event!);
//     _audioManager.start();
//
//     if (callType == StringeeObjectEventType.call) {
//       makeOrInitAnswerCall();
//     } else {
//       makeOrInitAnswerCall2();
//     }
//   }
//
//   Future makeOrInitAnswerCall2() async {
//     if (!showIncomingUi) {
//       stringCall2 = StringeeCall2(_client);
//     }
//     // Listen events
//     stringCall2!.eventStreamController.stream.listen((event) {
//       Map<dynamic, dynamic> map = event;
//       switch (map['eventType']) {
//         case StringeeCall2Events.didChangeSignalingState:
//           handleSignalingStateChangeEvent(map['body']);
//           break;
//         case StringeeCall2Events.didChangeMediaState:
//           handleMediaStateChangeEvent(map['body']);
//           break;
//         case StringeeCall2Events.didReceiveCallInfo:
//           handleReceiveCallInfoEvent(map['body']);
//           break;
//         case StringeeCall2Events.didHandleOnAnotherDevice:
//           handleHandleOnAnotherDeviceEvent(map['body']);
//           break;
//         case StringeeCall2Events.didReceiveLocalStream:
//           handleReceiveLocalStreamEvent(map['body']);
//           break;
//         case StringeeCall2Events.didReceiveRemoteStream:
//           handleReceiveRemoteStreamEvent(map['body']);
//           break;
//         case StringeeCall2Events.didAddVideoTrack:
//           handleAddVideoTrackEvent(map['body']);
//           break;
//         case StringeeCall2Events.didRemoveVideoTrack:
//           handleRemoveVideoTrackEvent(map['body']);
//           break;
//         default:
//           break;
//       }
//     });
//
//     if (showIncomingUi) {
//       stringCall2!.initAnswer().then((event) {
//         bool status = event['status'];
//         if (!status) {
//           clearDataEndDismiss();
//         }
//       });
//     } else {
//       final parameters = {
//         'from': fromUserId,
//         'to': toUserId,
//         'isVideoCall': isVideoCall,
//         'customData': null,
//         'videoQuality': VideoQuality.fullHd,
//       };
//
//       stringCall2!.makeCall(parameters).then((result) {
//         bool status = result['status'];
//         int code = result['code'];
//         String message = result['message'];
//         if (!status) {
//           Navigator.pop(navigatorKey!.currentContext!);
//         }
//       });
//     }
//   }
//
//   void changeAudioDevice(AudioDevice device) {
//     _audioManager.selectDevice(device).then((value) {
//       print(value);
//       if (value.status) {
//         audioDevice = device;
//       }
//     });
//   }
//
//   void handleSignalingStateChangeEvent(StringeeSignalingState state) {
//     print('handleSignalingStateChangeEvent - $state');
//     status = state.toString().split('.')[1];
//     notifyListeners();
//     switch (state) {
//       case StringeeSignalingState.calling:
//         break;
//       case StringeeSignalingState.ringing:
//         break;
//       case StringeeSignalingState.answered:
//         break;
//       case StringeeSignalingState.busy:
//         clearDataEndDismiss();
//         break;
//       case StringeeSignalingState.ended:
//         clearDataEndDismiss();
//         break;
//       default:
//         break;
//     }
//   }
//
//   void handleMediaStateChangeEvent(StringeeMediaState state) {
//     print('handleMediaStateChangeEvent - $state');
//     status = state.toString().split('.')[1];
//     notifyListeners();
//   }
//
//   void handleReceiveCallInfoEvent(Map<dynamic, dynamic> info) {
//     print('handleReceiveCallInfoEvent - $info');
//   }
//
//   void handleHandleOnAnotherDeviceEvent(StringeeSignalingState state) {
//     print('handleHandleOnAnotherDeviceEvent - $state');
//     if (state == StringeeSignalingState.answered ||
//         state == StringeeSignalingState.ended ||
//         state == StringeeSignalingState.busy) {
//       clearDataEndDismiss();
//     }
//   }
//
//   void handleReceiveLocalStreamEvent(String callId) {
//     if (localScreen != null) {
//       localScreen = null;
//       notifyListeners();
//       Future.delayed(const Duration(milliseconds: 200), () {
//         localScreen = StringeeVideoView(
//           callId,
//           true,
//           alignment: Alignment.topRight,
//           margin: const EdgeInsets.only(top: 25.0, right: 25.0),
//           height: 150.0,
//           width: 100.0,
//           scalingType: ScalingType.fit,
//         );
//         notifyListeners();
//       });
//     } else {
//       localScreen = StringeeVideoView(
//         callId,
//         true,
//         alignment: Alignment.topRight,
//         margin: const EdgeInsets.only(top: 25.0, right: 25.0),
//         height: 150.0,
//         width: 100.0,
//         scalingType: ScalingType.fit,
//       );
//       notifyListeners();
//     }
//   }
//
//   void handleAddVideoTrackEvent(StringeeVideoTrack track) {
//     print('handleAddVideoTrackEvent - ${track.id}');
//     if (track.isLocal) {
//       localScreen = null;
//       notifyListeners();
//       Future.delayed(const Duration(milliseconds: 200), () {
//         localScreen = track.attach(
//           alignment: Alignment.topRight,
//           margin: const EdgeInsets.only(top: 25.0, right: 25.0),
//           height: 150.0,
//           width: 100.0,
//           scalingType: ScalingType.fit,
//         );
//         notifyListeners();
//       });
//     } else {
//       remoteScreen = null;
//       notifyListeners();
//       Future.delayed(const Duration(milliseconds: 200), () {
//         remoteScreen = track.attach(
//           isMirror: false,
//           scalingType: ScalingType.fit,
//         );
//         notifyListeners();
//       });
//     }
//   }
//
//   void handleRemoveVideoTrackEvent(StringeeVideoTrack track) {
//     print('handleRemoveVideoTrackEvent - ${track.id}');
//   }
//
//   Future makeOrInitAnswerCall() async {
//     if (!showIncomingUi) {
//       stringCall = StringeeCall(_client);
//     }
//
//     // Listen events
//     stringCall!.eventStreamController.stream.listen((event) {
//       Map<dynamic, dynamic> map = event;
//       print("Call " + map.toString());
//       switch (map['eventType']) {
//         case StringeeCallEvents.didChangeSignalingState:
//           handleSignalingStateChangeEvent(map['body']);
//           break;
//         case StringeeCallEvents.didChangeMediaState:
//           handleMediaStateChangeEvent(map['body']);
//           break;
//         case StringeeCallEvents.didReceiveCallInfo:
//           handleReceiveCallInfoEvent(map['body']);
//           break;
//         case StringeeCallEvents.didHandleOnAnotherDevice:
//           handleHandleOnAnotherDeviceEvent(map['body']);
//           break;
//         case StringeeCallEvents.didReceiveLocalStream:
//           handleReceiveLocalStreamEvent(map['body']);
//           break;
//         case StringeeCallEvents.didReceiveRemoteStream:
//           handleReceiveRemoteStreamEvent(map['body']);
//           break;
//         default:
//           break;
//       }
//     });
//
//     if (showIncomingUi) {
//       stringCall!.initAnswer().then((event) {
//         bool status = event['status'];
//         if (!status) {
//           clearDataEndDismiss();
//         }
//       });
//     } else {
//       final parameters = {
//         'from': fromUserId,
//         'to': toUserId,
//         'isVideoCall': isVideoCall,
//         'customData': null,
//         'videoQuality': VideoQuality.fullHd,
//       };
//
//       stringCall!.makeCall(parameters).then((result) {
//         bool status = result['status'];
//         int code = result['code'];
//         String message = result['message'];
//         if (!status) {
//           Navigator.pop(navigatorKey.currentContext!);
//         }
//       });
//     }
//   }
//
//   void endCallTapped() {
//     if (callType == StringeeObjectEventType.call) {
//       stringCall!.hangup().then((result) {
//         bool status = result['status'];
//         if (status) {
//           if (Platform.isAndroid) {
//             clearDataEndDismiss();
//           }
//         }
//       });
//     } else if (callType == StringeeObjectEventType.call2) {
//       stringCall2!.hangup().then((result) {
//         bool status = result['status'];
//         if (status) {
//           if (Platform.isAndroid) {
//             clearDataEndDismiss();
//           }
//         }
//       });
//     }
//   }
//
//   void acceptCallTapped() {
//     if (callType == StringeeObjectEventType.call) {
//       stringCall!.answer().then((result) {
//         bool status = result['status'];
//         if (!status) {
//           clearDataEndDismiss();
//         }
//       });
//     } else if (callType == StringeeObjectEventType.call2) {
//       stringCall2!.answer().then((result) {
//         bool status = result['status'];
//         if (!status) {
//           clearDataEndDismiss();
//         }
//       });
//     }
//
//     showIncomingUi = !showIncomingUi;
//     notifyListeners();
//   }
//
//   void rejectCallTapped() {
//     if (callType == StringeeObjectEventType.call) {
//       stringCall!.reject().then((result) {
//         if (Platform.isAndroid) {
//           clearDataEndDismiss();
//         }
//       });
//     } else if (callType == StringeeObjectEventType.call2) {
//       stringCall2!.reject().then((result) {
//         if (Platform.isAndroid) {
//           clearDataEndDismiss();
//         }
//       });
//     }
//   }
//
//   void clearDataEndDismiss() {
//     _audioManager.removeListener(_event!);
//     _audioManager.stop();
//     if (callType == StringeeObjectEventType.call) {
//       stringCall!.destroy();
//       stringCall = null;
//       Navigator.pop(navigatorKey.currentContext!);
//     } else if (callType == StringeeObjectEventType.call2) {
//       stringCall2!.destroy();
//       stringCall2 = null;
//       Navigator.pop(navigatorKey.currentContext!);
//     } else {
//       Navigator.pop(navigatorKey.currentContext!);
//     }
//   }
//
//   void toggleSwitchCamera() {
//     if (callType == StringeeObjectEventType.call) {
//       stringCall!.switchCamera().then((result) {
//         bool status = result['status'];
//         if (status) {}
//       });
//     } else if (callType == StringeeObjectEventType.call2) {
//       stringCall2!.switchCamera().then((result) {
//         bool status = result['status'];
//         if (status) {}
//       });
//     }
//   }
//
//   void handleReceiveRemoteStreamEvent(String callId) {
//     if (remoteScreen != null) {
//       remoteScreen = null;
//       notifyListeners();
//       Future.delayed(const Duration(milliseconds: 200), () {
//         remoteScreen = StringeeVideoView(
//           callId,
//           false,
//           isMirror: false,
//           scalingType: ScalingType.fit,
//         );
//         notifyListeners();
//       });
//     } else {
//       remoteScreen = StringeeVideoView(
//         callId,
//         false,
//         isMirror: false,
//         scalingType: ScalingType.fit,
//       );
//       notifyListeners();
//     }
//   }
//
//   void toggleSpeaker() {
//     if (_availableAudioDevices.length < 3) {
//       if (_availableAudioDevices.length <= 1) {
//         return;
//       }
//       int position = _availableAudioDevices.indexOf(audioDevice);
//       if (position == _availableAudioDevices.length - 1) {
//         changeAudioDevice(_availableAudioDevices[0]);
//       } else {
//         changeAudioDevice(_availableAudioDevices[position + 1]);
//       }
//     } else {
//       showModalBottomSheet(
//         context: navigatorKey.currentContext!,
//         builder: (context) {
//           return ListView.separated(
//             itemCount: _availableAudioDevices.length,
//             separatorBuilder: (context, index) {
//               return const Divider();
//             },
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(_availableAudioDevices[index].name!),
//                 onTap: () {
//                   changeAudioDevice(_availableAudioDevices[index]);
//                   Navigator.pop(context);
//                 },
//               );
//             },
//           );
//         },
//       );
//     }
//   }
//
//   void toggleMicro() {
//     if (callType == StringeeObjectEventType.call) {
//       stringCall!.mute(!isMute).then((result) {
//         bool status = result['status'];
//         if (status) {
//           isMute = !isMute;
//           notifyListeners();
//         }
//       });
//     } else if (callType == StringeeObjectEventType.call2) {
//       stringCall2!.mute(!isMute).then((result) {
//         bool status = result['status'];
//         if (status) {
//           isMute = !isMute;
//           notifyListeners();
//         }
//       });
//     }
//   }
//
//   void toggleVideo() {
//     if (callType == StringeeObjectEventType.call) {
//       stringCall!.enableVideo(!isVideoEnable).then((result) {
//         bool status = result['status'];
//         if (status) {
//           isVideoEnable = !isVideoEnable;
//           notifyListeners();
//         }
//       });
//     } else if (callType == StringeeObjectEventType.call2) {
//       stringCall2!.enableVideo(!isVideoEnable).then((result) {
//         bool status = result['status'];
//         if (status) {
//           isVideoEnable = !isVideoEnable;
//           notifyListeners();
//         }
//       });
//     }
//   }
//
//   void createForegroundServiceNotification() {
//     flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
//       android: AndroidInitializationSettings('ic_launcher'),
//     ));
//
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.startForegroundService(
//           1,
//           'Screen capture',
//           'Capturing',
//           notificationDetails: const AndroidNotificationDetails(
//             'Test id',
//             'Test name',
//             channelDescription: 'Test description',
//             importance: Importance.defaultImportance,
//             priority: Priority.defaultPriority,
//           ),
//         );
//   }
// }
