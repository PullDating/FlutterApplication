import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
class AuthResponse with _$AuthResponse {
  // ignore: invalid_annotation_target
  const factory AuthResponse({@JsonKey(name: 'user_exists') required bool userExists, String? token, String? uuid}) =
      _AuthResponse;

  factory AuthResponse.fromJson(Map<String, Object?> json) => _$AuthResponseFromJson(json);
}
