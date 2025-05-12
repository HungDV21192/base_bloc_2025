import 'dart:convert';
import 'dart:io';

import 'package:base_code/features/home/bloc/home_bloc.dart';
import 'package:base_code/features/home/bloc/home_event.dart';
import 'package:base_code/features/home/bloc/home_state.dart';
import 'package:base_code/features/stringee_call/stringee_service.dart';
import 'package:base_code/widgets/custom_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stringee_plugin/stringee_plugin.dart';
import 'package:uuid/uuid.dart';

String createTokenJWT(String userId) {
  const apiKeySid =
      'SK.0.G3K3pzAQvMuqA4DThpWmz4h2NqatygCj'; // API Key SID của bạn
  const apiKeySecret =
      'dHppOXBTSnpCVmY2NFBnQlFkbDVOZnA2ZDE2RW9RQg=='; // API Secret Key

  final header = {
    'alg': 'HS256',
    'typ': 'JWT',
    'cty': 'stringee-api;v=1',
  };

  final payload = {
    'jti': const Uuid().v4(),
    // Tạo jti random mỗi lần (bạn cần thêm package uuid nhé)
    'iss': apiKeySid,
    'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 8 * 3600,
    // Expire sau 8 tiếng
    'userId': userId,
  };

  String base64UrlEncodeNoPadding(List<int> bytes) {
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  final headerEncoded =
      base64UrlEncodeNoPadding(utf8.encode(json.encode(header)));
  final payloadEncoded =
      base64UrlEncodeNoPadding(utf8.encode(json.encode(payload)));
  final toSign = '$headerEncoded.$payloadEncoded';
  final hmac = Hmac(sha256, utf8.encode(apiKeySecret));
  final signature = hmac.convert(utf8.encode(toSign));
  final signatureEncoded = base64UrlEncodeNoPadding(signature.bytes);
  final jwt = '$toSign.$signatureEncoded';
  return jwt;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  String? imageUrl;
  final StringeeService _stringeeService = StringeeService();

  // String token =
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6InN0cmluZ2VlLWFwaTt2PTEifQ.eyJqdGkiOiJjOGY0ZjBhNy05ZTZiLTRkZjEtOGI5NC0xMmJmOWEyMTU3ZDciLCJpc3MiOiJTSy4wLklsOGxmSUF6MmZzN1EyUjFYMGFzRWY2NlQ3UlJaTiIsImV4cCI6MTc0NTg0MDU0OCwidXNlcklkIjoiYWJjMTIzIn0.PA0_cBH2XMXg0LvTkjn0BA4aX2WhobIzfKBl4Lxrz8I';

  //
  // final header = {'alg': 'HS256', 'typ': 'JWT', "cty": "stringee-api;v=1"};
  // final payload = {
  //   "jti": "c8f4f0a7-9e6b-4df1-8b94-12bf9a2157d7", //JWT ID
  //   "iss": "SK.0.Il8lfIAz2fs7Q2R1X0asEf66T7RRZN", //API key sid
  //   "exp": DateTime.now().add(Duration(minutes: 30)).millisecondsSinceEpoch ~/
  //       1000, //expiration time
  //   "userId": "abc123"
  // };

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _stringeeService.connect(createTokenJWT('bruno2ouf'));
  }

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();

    if (statuses[Permission.microphone]!.isDenied ||
        statuses[Permission.camera]!.isDenied) {
      return false;
    } else {
      return true;
    }
  }

  void callTapped() async {
    final check = await requestPermissions();
    if (check) {
      _stringeeService.callTapped(
        isVideoCall: true,
        callType: StringeeObjectEventType.call,
        toUser: 'jaykind',
      );
    }
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
          onPressed: () {},
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
        child: const Icon(Icons.call),
        onPressed: () => callTapped(),
      ),
    );
  }
}
