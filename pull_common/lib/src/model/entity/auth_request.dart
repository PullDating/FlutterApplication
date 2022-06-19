import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request.freezed.dart';
part 'auth_request.g.dart';

@freezed
class AuthRequest with _$AuthRequest {
  const factory AuthRequest.emailPassword(String email, String password) = _EmailPassword;

  factory AuthRequest.fromJson(Map<String, Object?> json) => _$AuthRequestFromJson(json);
}
