import 'package:base_code/main.dart';
import 'package:base_code/stringee_call/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:stringee_plugin/stringee_plugin.dart';

class StringeeService with ChangeNotifier {
  final StringeeClient _client = StringeeClient();

  Future<void> connect(String token) async {
    _client.connect(token);
    _client.eventStreamController.stream.listen((event) {
      Map<dynamic, dynamic> map = event;
      switch (map['eventType']) {
        case StringeeClientEvents.didConnect:
          handleDidConnectEvent();
          break;
        case StringeeClientEvents.didDisconnect:
          handleDidDisconnectEvent();
          break;
        case StringeeClientEvents.didFailWithError:
          handleDidFailWithErrorEvent(
              map['body']['code'], map['body']['message']);
          break;
        case StringeeClientEvents.requestAccessToken:
          handleRequestAccessTokenEvent();
          break;
        case StringeeClientEvents.didReceiveCustomMessage:
          handleDidReceiveCustomMessageEvent(map['body']);
          break;
        case StringeeClientEvents.incomingCall:
          //Todo: Khi có cuộc gọi đến (Loại 1)
          StringeeCall call = map['body'];
          handleIncomingCallEvent(call, navigatorKey.currentContext!);
          break;
        case StringeeClientEvents.incomingCall2:
          //Todo: Khi có cuộc gọi đến (Loại 2)
          StringeeCall2 call = map['body'];
          handleIncomingCall2Event(call, navigatorKey.currentContext!);
          break;
        default:
          break;
      }
    });
  }

  void handleDidConnectEvent() {
    debugPrint("Did Connect Event");
  }

  void handleDidDisconnectEvent() {
    debugPrint("Did Dis Connect Event");
  }

  void handleDidFailWithErrorEvent(int code, String message) {
    print('check mesage $message');
    print('code: ' + code.toString() + '\nmessage: ' + message);
  }

  void handleRequestAccessTokenEvent() {
    print('Request new access token');
  }

  void handleDidReceiveCustomMessageEvent(Map<dynamic, dynamic> map) {
    print('from: ' +
        map['fromUserId'] +
        '\nmessage: ' +
        map['message'].toString());
  }

  void handleIncomingCallEvent(StringeeCall call, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          client: _client,
          fromUserId: call.from!,
          toUserId: call.to!,
          callType: StringeeObjectEventType.call,
          showIncomingUi: true,
          isVideoCall: call.isVideoCall,
          call: call,
        ),
      ),
    );
  }

  void handleIncomingCall2Event(StringeeCall2 call, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          client: _client,
          fromUserId: call.from!,
          toUserId: call.to!,
          showIncomingUi: true,
          isVideoCall: call.isVideoCall,
          callType: StringeeObjectEventType.call2,
          call2: call,
        ),
      ),
    );
  }

  void callTapped({
    bool isVideoCall = false,
    required StringeeObjectEventType callType,
    required String toUser,
  }) {
    if (toUser.isEmpty || !_client.hasConnected) return;
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
          builder: (context) => CallScreen(
                client: _client,
                fromUserId: _client.userId!,
                toUserId: toUser,
                showIncomingUi: false,
                isVideoCall: isVideoCall,
                callType: callType,
              )),
    );
  }
}
