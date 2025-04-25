import 'package:base_code/utils/constant.dart';
import 'package:flutter/material.dart';

class AuthBaseScreen extends StatefulWidget {
  const AuthBaseScreen({super.key, required this.body, this.indexScreen = 0});

  final Widget body;
  final int indexScreen;

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
      begin: const Offset(0, 1), // Bắt đầu từ dưới
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    Future.delayed(const Duration(milliseconds: 1000), () async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: widget.indexScreen == 2
                ? 400
                : (widget.indexScreen == 1 ? 300 : 200),
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
    );
  }
}
