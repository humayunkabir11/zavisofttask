class ApiResponse<T> {
  final bool status;
  final dynamic message;
  final dynamic error;
  final int? statusCode;
  final T? data;

  ApiResponse({
    required this.status,
    this.message,
    this.error,
    this.statusCode,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'],
      error: json['error'],
      statusCode: json['statusCode'],
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'],
    );
  }

  Map<String, dynamic> toJson(Object? Function(T)? toJsonT) {
    return {
      'status': status,
      'message': message,
      'error': error,
      'statusCode': statusCode,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
    };
  }
}
