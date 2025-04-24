import 'package:easy_localization/easy_localization.dart';

String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'username_error'.tr();
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'password_error'.tr();
  }
  return null;
}
