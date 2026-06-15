class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;

  ApiResponse({required this.success, this.data, this.error});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
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
  final int totalPages;

  PaginationMeta({
    this.total = 0,
    this.page = 1,
    this.limit = 10,
    this.totalPages = 1,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
    total: json['total'] ?? 0,
    page: json['page'] ?? 1,
    limit: json['limit'] ?? 10,
    totalPages: json['totalPages'] ?? 1,
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
