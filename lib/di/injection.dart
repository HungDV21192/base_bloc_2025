import 'package:base_code/features/auth/repository/auth_repository.dart';
import 'package:base_code/features/home/repository/home_repository.dart';
import 'package:base_code/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final apiService = ApiService();
const secureStorage = FlutterSecureStorage();

final authRepo = AuthRepository(
  storage: secureStorage,
  apiService: apiService,
);
final homeRepo = HomeRepository();
