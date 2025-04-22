import 'dart:io';

import 'package:base_code/features/home/bloc/home_bloc.dart';
import 'package:base_code/features/home/bloc/home_event.dart';
import 'package:base_code/features/home/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    final storage = FlutterSecureStorage();
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
    return Scaffold(
      appBar: AppBar(title: Text("Chào, $username")),
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
                  child: imageUrl == null ? Icon(Icons.person, size: 50) : null,
                ),
                SizedBox(height: 20),
                Text("Username: $username"),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () async {
          final source = await showDialog<ImageSource>(
            context: context,
            builder: (context) =>
                SimpleDialog(
                  title: Text("Chọn ảnh"),
                  children: [
                    SimpleDialogOption(
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.camera),
                      child: Text("Chụp ảnh"),
                    ),
                    SimpleDialogOption(
                      onPressed: () =>
                          Navigator.pop(context, ImageSource.gallery),
                      child: Text("Chọn từ thư viện"),
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
