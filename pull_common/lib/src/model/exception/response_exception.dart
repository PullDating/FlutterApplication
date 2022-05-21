import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_exception.freezed.dart';

@freezed
class ResponseException with _$ResponseException implements Exception {
  const factory ResponseException(int code, {String? message}) = _ResponseException;
}
