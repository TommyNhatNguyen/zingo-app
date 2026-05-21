class ApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? error;

  ApiResponse({required this.success, this.data, this.error});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is bool) {
      return ApiResponse(
        success: json['success'] ?? false,
        data: {'is_favorite': json['data']},
        error: json['error'],
      );
    }
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'],
      error: json['error'],
    );
  }

  factory ApiResponse.success(dynamic data) =>
      ApiResponse(success: true, data: data);
  factory ApiResponse.error(String error) =>
      ApiResponse(success: false, error: error);
}

class PaginationMeta {
  final int total;
  final int page;
  final int limit;

  PaginationMeta({this.total = 0, this.page = 1, this.limit = 10});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
    total: json['total'],
    page: json['page'],
    limit: json['limit'],
  );
}

class PaginatedApiResult<T> {
  final bool success;
  final PaginationMeta meta;
  final List<T>? data;
  final String? error;

  PaginatedApiResult({
    required this.success,
    required this.meta,
    this.data = const [],
    this.error,
  });

  factory PaginatedApiResult.fromJson(Map<String, dynamic> json) =>
      PaginatedApiResult(
        success: json['success'] ?? false,
        meta: PaginationMeta.fromJson(json['meta'] ?? {}),
        data: json['data'],
        error: json['error'],
      );
}
