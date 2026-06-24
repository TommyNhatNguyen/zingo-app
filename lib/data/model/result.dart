import 'package:zingo/data/model/api_error.dart';

sealed class Result<T> {
  const Result();

  factory Result.ok(T data) => Ok(data);

  factory Result.error(Exception error) => Error(error);
  factory Result.errorAPI(ApiErrorResponse error) => ErrorAPI(error);
}

final class Ok<T> extends Result<T> {
  final T data;

  Ok(this.data);

  @override
  String toString() {
    return 'Ok<${T.runtimeType}>(data: $data)';
  }
}

class Error<T> extends Result<T> {
  final Exception error;

  Error(this.error);

  @override
  String toString() {
    return 'Error<${T.runtimeType}>(error: $error)';
  }
}

final class ErrorAPI<T> extends Result<T> {
  final ApiErrorResponse error;

  ErrorAPI(this.error);

  @override
  String toString() {
    return 'ErrorApiResponse<${T.runtimeType}>(error: $error)';
  }
}