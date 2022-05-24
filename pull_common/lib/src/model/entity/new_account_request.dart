import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_account_request.freezed.dart';
part 'new_account_request.g.dart';

@freezed
class NewAccountRequest with _$NewAccountRequest {
  const factory NewAccountRequest.phone(String phone) = _Phone;

  factory NewAccountRequest.fromJson(Map<String, Object?> json) => _$NewAccountRequestFromJson(json);
}
