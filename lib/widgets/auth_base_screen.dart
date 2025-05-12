import 'package:base_code/app/config/constant.dart';
import 'package:flutter/material.dart';

class AuthBaseScreen extends StatefulWidget {
  const AuthBaseScreen({
    super.key,
    required this.body,
    this.indexScreen = 0,
    this.floatACBT,
  });

  final Widget body;
  final int indexScreen;
  final Widget? floatACBT;

  @override
  State<AuthBaseScreen> createState() => _AuthBaseScreenState();
}

class _AuthBaseScreenState extends State<AuthBaseScreen>
    with SingleTickerProviderStateMixin {
  var showDetail = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    Future.delayed(Duration(milliseconds: widget.indexScreen == 0 ? 1000 : 500),
        () async {
      setState(() {
        showDetail = true;
      });
      _controller.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () => hideKeyboard(context),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: widget.indexScreen == 2
                  ? 500
                  : (widget.indexScreen == 1 ? 450 : 250),
              child: Image.asset(
                ImageAssets.image_background,
                fit: BoxFit.fill,
              ),
            ),
            if (showDetail)
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: widget.body,
                ),
              )
          ],
        ),
      ),
      floatingActionButton: widget.floatACBT,
    );
  }
}
