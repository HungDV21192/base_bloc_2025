import 'dart:io';

import 'package:base_code/app/config/router_name.dart';
import 'package:base_code/features/home/bloc/home_bloc.dart';
import 'package:base_code/features/home/bloc/home_event.dart';
import 'package:base_code/features/home/bloc/home_state.dart';
import 'package:base_code/widgets/custom_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    const storage = FlutterSecureStorage();
    final storedUsername = await storage.read(key: 'username');
    setState(() => username = storedUsername);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      context.read<HomeBloc>().add(UploadImageEvent(File(picked.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      titleAppBar: '${'hello'.tr()} JaykinD',
      actions: [
        IconButton(
          onPressed: () => context.push(RouterName.Settings),
          icon: const Icon(Icons.settings),
        ),
      ],
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeImageUploaded) {
            setState(() => imageUrl = state.imageUrl);
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl!) : null,
                  child: imageUrl == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
                const SizedBox(height: 20),
                Text("Username: $username"),
              ],
            ),
          );
        },
      ),
      floatButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () async {
          final source = await showDialog<ImageSource>(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text("Chọn ảnh"),
              children: [
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                  child: const Text("Chụp ảnh"),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                  child: const Text("Chọn từ thư viện"),
                ),
              ],
            ),
          );
          if (source != null) await _pickImage(source);
        },
      ),
    );
  }
}
