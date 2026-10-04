import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/storage/storage_service.dart';

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.message = '',
    this.data,
    this.error,
    required this.statusCode,
  });
}

class ApiService {
  static const Duration _timeout = Duration(seconds: 15);

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    final token = StorageService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<ApiResponse<dynamic>> get(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(_timeout);
      return _parseResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        error: 'Unable to connect to Gram Mitra server. Please check your network.',
        statusCode: 0,
      );
    } on TimeoutException {
      return ApiResponse(
        success: false,
        error: 'Connection timed out. Please try again.',
        statusCode: 408,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Something went wrong: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  static Future<ApiResponse<dynamic>> post(String url, Map<String, dynamic> body) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(_timeout);
      return _parseResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        error: 'Unable to connect to Gram Mitra server. Please check your network.',
        statusCode: 0,
      );
    } on TimeoutException {
      return ApiResponse(
        success: false,
        error: 'Connection timed out. Please try again.',
        statusCode: 408,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: 'Something went wrong: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  static ApiResponse<dynamic> _parseResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      decoded = null;
    }

    final isOk = response.statusCode >= 200 && response.statusCode < 300;

    if (decoded is Map<String, dynamic>) {
      final success = decoded['success'] == true || isOk;
      final message = decoded['message']?.toString() ?? '';
      final error = decoded['error']?.toString();
      final data = decoded['data'] ?? decoded;

      return ApiResponse(
        success: success,
        message: message,
        data: data,
        error: error,
        statusCode: response.statusCode,
      );
    }

    return ApiResponse(
      success: isOk,
      data: decoded,
      statusCode: response.statusCode,
      error: isOk ? null : 'Request failed with status code ${response.statusCode}',
    );
  }
}
