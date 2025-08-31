class ApiResponse<T> {
  final T? data;
  final String? message;
  final bool isSuccess;
  final int? statusCode;

  ApiResponse._({
    this.data,
    this.message,
    required this.isSuccess,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {int? statusCode}) {
    return ApiResponse._(data: data, isSuccess: true, statusCode: statusCode);
  }

  factory ApiResponse.error(String? message, {int? statusCode}) {
    return ApiResponse._(
      message: message,
      isSuccess: false,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.loading() {
    return ApiResponse._(isSuccess: false);
  }
}
