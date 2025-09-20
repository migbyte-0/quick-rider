import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/api_endpoints.dart';
import '../services/secure_storage.dart';

class DioClient {
  final Dio dio;
  final Logger log;
  final SecureStorage storage;

  DioClient({required this.dio, required this.log, required this.storage}) {
    dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    );

    dio.interceptors.add(_LoggingInterceptor(log));
    dio.interceptors.add(InterceptorsWrapper(onRequest: _onRequest));
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  final Logger log;
  _LoggingInterceptor(this.log);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.i('➡️ ${options.method} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log.i(' ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.e(
      ' ${err.response?.statusCode} ${err.requestOptions.uri}\nError: ${err.message}',
    );
    super.onError(err, handler);
  }
}
