import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:base_code/main.dart';
import 'package:flutter/material.dart';

final GlobalKey flushBarKey = GlobalKey();

class FlushBarServices {
  static void showError(
    String message,
  ) {
    showFlushbar(
      context: navigatorKey.currentContext!,
      flushbar: Flushbar(
        key: flushBarKey,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        message: message,
        messageSize: 16,
        borderRadius: BorderRadius.circular(10),
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
      )..show(navigatorKey.currentContext!),
    );
  }

  static void showSuccess(
    String message,
  ) {
    showFlushbar(
      context: navigatorKey.currentContext!,
      flushbar: Flushbar(
        key: flushBarKey,
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        message: message,
        messageSize: 14,
        borderRadius: BorderRadius.circular(10),
        icon: const Icon(
          Icons.check_circle,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green,
        reverseAnimationCurve: Curves.easeInOut,
      )..show(navigatorKey.currentContext!),
    );
  }

  static void showWarning(
    String message,
  ) {
    showFlushbar(
      context: navigatorKey.currentContext!,
      flushbar: Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        message: message,
        messageSize: 16,
        borderRadius: BorderRadius.circular(10),
        icon: const Icon(
          Icons.warning,
          color: Colors.white,
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.yellow[800]!,
        reverseAnimationCurve: Curves.easeInOut,
      )..show(navigatorKey.currentContext!),
    );
  }
}
