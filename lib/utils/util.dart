import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

void showLoading({String? message}) {
  EasyLoading.show(status: message);
}

void hideLoading() {
  if (EasyLoading.isShow) {
    EasyLoading.dismiss();
  }
}

void backToPage(BuildContext context, String routeName) {
  context.goNamed(routeName);
}
