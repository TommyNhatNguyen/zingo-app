class ApiResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? error;

  ApiResponse({required this.success, this.data, this.error});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    success: json['success'] ?? false,
    data: json['data'],
    error: json['error'],
  );

  factory ApiResponse.success(dynamic data) =>
      ApiResponse(success: true, data: data);
  factory ApiResponse.error(String error) =>
      ApiResponse(success: false, error: error);
}

class Pagination {
  final int total;
  final int page;
  final int limit;

  Pagination({this.total = 0, this.page = 1, this.limit = 10});

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json['total'],
    page: json['page'],
    limit: json['limit'],
  );
}

class PaginatedApiResponse {
  final bool success;
  final Pagination pagination;
  final List<dynamic>? data;

  PaginatedApiResponse({
    required this.success,
    required this.pagination,
    this.data = const [],
  });

  factory PaginatedApiResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedApiResponse(
        success: json['success'] ?? false,
        pagination: Pagination.fromJson(json['pagination'] ?? {}),
        data: json['data'],
      );
}
