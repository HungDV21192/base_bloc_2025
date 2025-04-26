import 'package:easy_localization/easy_localization.dart';

class Validations {
  static String? isValidAccount(String? account) {
    if ((account ?? '').isNotEmpty) {
      return null;
    } else {
      return 'username_error'.tr();
    }
  }

  static String? isValidPassword(String? password) {
    if ((password ?? '').isNotEmpty) {
      return null;
    } else {
      return 'password_error'.tr();
    }
  }

  static String? isValidConfirmPW(String? password, String? confirmPW) {
    if ((confirmPW ?? '').isNotEmpty && (confirmPW == password)) {
      return null;
    } else {
      return 'password_error'.tr();
    }
  }
}
