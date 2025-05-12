import 'package:base_code/app/config/constant.dart';
import 'package:base_code/utils/message.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ApiService {
  final Dio _dio;

  ApiService._internal(this._dio);

  factory ApiService() {
    final dio = Dio(BaseOptions(
      baseUrl: Base.URL_PROD,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    //Todo: Thêm interceptor nếu muốn logging
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    return ApiService._internal(dio);
  }

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return ApiResult.success(response.data);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return ApiResult.success(response.data);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return ApiResult.success(response.data);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return ApiResult.success(response.data);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return ApiResult.success(response.data);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  ApiResult<T> _handleError<T>(dynamic error) {
    String message = 'Unknown error occurred';
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout) {
        FlushBarServices.showError('Kết nối thất bại, vui lòng thử lại sau!');
      } else if (error.type == DioExceptionType.badResponse) {
        if (error.response?.data['code'] == '010') {
          // NavigationService.navigateAndRemoveUntil(RouterName.LoginView);
          FlushBarServices.showError(error.response?.data['message']);
        } else {
          FlushBarServices.showError(error.response?.data['message']);
        }
      } else if (error.type == DioExceptionType.connectionError) {
        //Todo: Không có kết nối mạng.
      } else {
        FlushBarServices.showError(error.toString());
        EasyLoading.dismiss();
      }
      // if (error.response != null) {
      //   message =
      //       'Error ${error.response?.statusCode}: ${error.response?.statusMessage}';
      // } else {
      //   message = error.message ?? 'Connection failed';
      // }
    }
    return ApiResult.failure(message);
  }
}

class ApiResult<T> {
  final T? data;
  final String? error;

  ApiResult._(this.data, this.error);

  factory ApiResult.success(T? data) => ApiResult._(data, null);

  factory ApiResult.failure(String error) => ApiResult._(null, error);

  bool get isSuccess => error == null;
}
