import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';



class AppLogInterceptor extends Interceptor {
  final JsonEncoder encoder = const JsonEncoder.withIndent('  ');

  String _prettyJson(dynamic data) {
    try {
      if (data is String) {
        return encoder.convert(json.decode(data));
      }
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint("\x1B[34m━━━━━━━━━━ REQUEST ━━━━━━━━━━\x1B[0m");
    debugPrint("➡️  METHOD: ${options.method}");
    debugPrint("➡️  URL: ${options.uri}");

    if (options.headers.isNotEmpty) {
      debugPrint("\x1B[33m--- Headers ---\x1B[0m");
      debugPrint(_prettyJson(options.headers));
    }

    if (options.queryParameters.isNotEmpty) {
      debugPrint("\x1B[36m--- Query ---\x1B[0m");
      debugPrint(_prettyJson(options.queryParameters));
    }

    if (options.data != null) {
      debugPrint("\x1B[32m--- Body ---\x1B[0m");
      debugPrint(_prettyJson(options.data));
    }

    debugPrint("\x1B[34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\x1B[0m");
    options.extra["start_time"] = DateTime.now();

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra["start_time"] as DateTime?;
    final duration = start != null
        ? DateTime.now().difference(start).inMilliseconds
        : 0;

    debugPrint("\x1B[32m━━━━━━━━━━ RESPONSE ━━━━━━━━━━\x1B[0m");
    debugPrint(
      "✅ ${response.statusCode} | ${response.requestOptions.method} | $duration ms",
    );
    debugPrint("URL: ${response.requestOptions.uri}");

    debugPrint("\x1B[35m--- Response Data ---\x1B[0m");

    debugPrint(_prettyJson(response.data));

    debugPrint("\x1B[32m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\x1B[0m");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint("\x1B[31m━━━━━━━━━━ ERROR ━━━━━━━━━━\x1B[0m");
    debugPrint("❌ ERROR: ${err.message}");
    debugPrint("URL: ${err.requestOptions.uri}");

    if (err.response != null) {
      debugPrint("\x1B[31m--- Server Response ---\x1B[0m");
      debugPrint(_prettyJson(err.response?.data));
    }

    debugPrint("\x1B[31m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\x1B[0m");

    final message = extractMessage(err.response?.data);


    super.onError(err, handler);
  }

  String extractMessage(dynamic data) {
    try {
      // If data itself is a string
      if (data is String) return data;

      // If direct `message` is string
      if (data is Map && data['message'] is String) {
        return data['message'];
      }

      // If message is nested: { "message": { "message": "..." } }
      if (data is Map && data['message'] is Map) {
        final inner = data['message'];
        if (inner['message'] is String) return inner['message'];
        if (inner['error'] is String) return inner['error']; // fallback
      }

      // If error wrapped inside dio exception response.data
      if (data is Map && data['error'] is String) {
        return data['error'];
      }

      return "Something went wrong!"; // default fallback
    } catch (e) {
      return "Something went wrong!";
    }
  }
}
