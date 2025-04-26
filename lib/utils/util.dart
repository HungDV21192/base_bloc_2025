import 'package:flutter_easyloading/flutter_easyloading.dart';

void showLoading({String? message}) {
  EasyLoading.show();
}

void hideLoading() {
  if (EasyLoading.isShow) {
    EasyLoading.dismiss();
  }
}
