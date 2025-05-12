import 'package:base_code/app/config/constant.dart';
import 'package:base_code/services/api_service.dart';
import 'package:base_code/utils/message.dart';

enum Environment { dev, prod }

class EnvController {
  var _env = Environment.prod;

  Environment get env => _env;

  String get baseUrl {
    switch (_env) {
      case Environment.dev:
        return Base.URL_DEV;
      case Environment.prod:
        return Base.URL_PROD;
    }
  }

  void toggleEnvironment() {
    final apiSvc = ApiService();
    _env = (_env == Environment.dev) ? Environment.prod : Environment.dev;
    apiSvc.updateBaseUrl(baseUrl);
    FlushBarServices.showSuccess(env.name.toUpperCase());
  }
}
