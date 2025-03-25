import 'dart:convert';
import 'package:dio/dio.dart';
import '../components/toast/toast.dart';

class ApiService {
  late String _baseUrl;
  final Dio _dio;

  ApiService(String baseUrl)
      : _baseUrl = baseUrl,
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['startTime'] = DateTime.now();
        _logRequest(options);
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logResponse(response);
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _logError(e);
        _handleError(e);
        return handler.next(e);
      },
    ));
  }

  Future<dynamic> get({
    required String endpoint,
    String? baseUrl,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    bool showErrorToast = true,
  }) async {
    return _executeRequest(
      endpoint: endpoint,
      baseUrl: baseUrl,
      queryParams: queryParams,
      headers: headers,
      method: 'GET',
      showErrorToast: showErrorToast,
    );
  }

  Future<dynamic> post({
    required String endpoint,
    String? baseUrl,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    bool showErrorToast = true,
  }) async {
    return _executeRequest(
      endpoint: endpoint,
      baseUrl: baseUrl,
      queryParams: queryParams,
      headers: headers,
      body: body,
      method: 'POST',
      showErrorToast: showErrorToast,
    );
  }

  Future<dynamic> put({
    required String endpoint,
    String? baseUrl,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    bool showErrorToast = true,
  }) async {
    return _executeRequest(
      endpoint: endpoint,
      baseUrl: baseUrl,
      queryParams: queryParams,
      headers: headers,
      body: body,
      method: 'PUT',
      showErrorToast: showErrorToast,
    );
  }

  Future<dynamic> delete({
    required String endpoint,
    String? baseUrl,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    bool showErrorToast = true,
  }) async {
    return _executeRequest(
      endpoint: endpoint,
      baseUrl: baseUrl,
      queryParams: queryParams,
      headers: headers,
      body: body,
      method: 'DELETE',
      showErrorToast: showErrorToast,
    );
  }

  Future<dynamic> _executeRequest({
    required String endpoint,
    String? baseUrl,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic body,
    required String method,
    bool showErrorToast = true,
  }) async {
    try {
      String finalUrl = baseUrl ?? _baseUrl;
      final String fullUrl = '$finalUrl\\$endpoint';
      Options options = Options(
        method: method,
        headers: headers ?? {},
      );

      Response response = await _dio.request(
        fullUrl,
        queryParameters: queryParams,
        data: body,
        options: options,
      );

      return response.data;
    } catch (e) {
      if (showErrorToast && e is DioException) {
        _showErrorToast(e);
      }
      throw e;
    }
  }

  void _handleError(DioException e) {}

  void _showErrorToast(DioException e) {
    String message = 'Unknown error occurred';

    if (e.type == DioExceptionType.connectionTimeout) {
      message = 'Connection timeout. Please check your internet connection.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = 'Server is taking too long to respond.';
    } else if (e.type == DioExceptionType.badResponse) {
      message = _getMessageFromResponse(e.response) ??
          'Server error (${e.response?.statusCode ?? 'unknown'})';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection.';
    } else {
      message = e.message ?? 'Something went wrong.';
    }

    Toast.show(
      message: message,
      type: ToastType.error,
    );
  }

  String? _getMessageFromResponse(Response? response) {
    if (response?.data is Map) {
      return response?.data['message'] ?? response?.data['error'];
    }
    return null;
  }

  void _logRequest(RequestOptions options) {
    StringBuffer log = StringBuffer();
    log.writeln('\n📤 REQUEST: ${options.method} ${options.uri}');

    if (options.queryParameters.isNotEmpty) {
      log.writeln('Query Params: ${_prettyPrintJson(options.queryParameters)}');
    }
    if (options.headers.isNotEmpty) {
      log.writeln('Headers: ${_prettyPrintJson(options.headers)}');
    }
    if (options.data != null) {
      log.writeln('Body: ${_prettyPrintJson(options.data)}');
    }
    print(log.toString());
  }

  void _logResponse(Response response) {
    StringBuffer log = StringBuffer();
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;
    final latency =
        startTime != null ? DateTime.now().difference(startTime) : null;

    log.writeln(
        '\n📥 RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
    if (latency != null) {
      log.writeln('Latency: ${latency.inMilliseconds}ms');
    }
    log.writeln('Headers: ${_prettyPrintJson(response.headers.map)}');
    log.writeln('Body: ${_prettyPrintJson(response.data)}');
    print(log.toString());
  }

  void _logError(DioException e) {
    StringBuffer log = StringBuffer();
    final request = e.requestOptions;
    final response = e.response;

    log.writeln('\n❌ ERROR: ${request.method} ${request.uri}');
    if (response != null) {
      log.writeln('Status Code: ${response.statusCode}');
      log.writeln('Headers: ${_prettyPrintJson(response.headers.map)}');
      log.writeln('Body: ${_prettyPrintJson(response.data)}');
    } else {
      log.writeln('Error Type: ${e.type}');
      log.writeln('Error: ${e.message}');
    }
    print(log.toString());
  }

  String _prettyPrintJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  Future<T?> safeRequest<T>({
    required Future<dynamic> Function() request,
    T? defaultValue,
    bool showToastOnError = true,
  }) async {
    try {
      final response = await request();
      return response as T;
    } catch (e) {
      if (showToastOnError && e is DioException) {
        _showErrorToast(e);
      }
      return defaultValue;
    }
  }
}
