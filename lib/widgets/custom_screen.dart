import 'package:base_code/app/config/text_styles.dart';
import 'package:flutter/material.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({
    super.key,
    required this.titleAppBar,
    required this.body,
    this.bottomSheet,
    this.floatButton,
    this.leading,
    this.actions,
    this.canPop = true,
    this.onPopInvoked,
    this.isBack = true,
  });

  final String titleAppBar;
  final Widget body;
  final Widget? bottomSheet;
  final Widget? floatButton;
  final Widget? leading;
  final List<Widget>? actions;
  final bool canPop;
  final PopInvokedCallback? onPopInvoked;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: onPopInvoked,
      //Todo: Nếu cần cảnh báo khi người dùng back bằng phím Cứng (Show toast hoặc dialog cảnh báo thì call ở đây)
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              titleAppBar,
              style: TextStyles.large.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            leading: leading,
            actions: actions,
          ),
          body: body,
          bottomSheet: bottomSheet,
          floatingActionButton: floatButton,
        ),
      ),
    );
  }
}
