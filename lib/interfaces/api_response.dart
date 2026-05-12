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
