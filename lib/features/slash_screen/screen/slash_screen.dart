import 'package:base_code/app/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlashScreen extends StatefulWidget {
  const SlashScreen({super.key});

  @override
  State<SlashScreen> createState() => _SlashScreenState();
}

class _SlashScreenState extends State<SlashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2500), () async {
      context.go(RouterName.RegisterView);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar Splash Screen'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
      ),
    );
  }
}
