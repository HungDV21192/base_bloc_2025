import 'package:base_code/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final FlutterSecureStorage storage;
  final ApiService apiService;

  AuthRepository({required this.storage, required this.apiService});

  Future<bool> register(
      {required String username, required String password}) async {
    try {
      await apiService.get('path');
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> login(
      {required String username, required String password}) async {
    // if (password.length >= 8) {
    //   return true;
    // } else {
    //   return false;
    // }

    return true;
    // final savedUser = await storage.read(key: 'username');
    // final savedPass = await storage.read(key: 'password');
    // if (username == savedUser && password == savedPass) {
    //   await storage.write(key: 'token', value: 'fake_token');
    //   return true;
    // }
    // return false;
  }
}
