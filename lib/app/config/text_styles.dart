import 'package:base_code/main.dart';
import 'package:flutter/material.dart';

class TextStyles {
  TextStyles._();

  static TextStyle get large {
    return Theme.of(navigatorKey.currentContext!).textTheme.titleLarge!;
  }

  static TextStyle get medium {
    return Theme.of(navigatorKey.currentContext!).textTheme.titleMedium!;
  }

  static TextStyle get mediumButton {
    return Theme.of(navigatorKey.currentContext!).textTheme.titleMedium!;
  }

  static TextStyle get small {
    return Theme.of(navigatorKey.currentContext!).textTheme.titleSmall!;
  }
}
