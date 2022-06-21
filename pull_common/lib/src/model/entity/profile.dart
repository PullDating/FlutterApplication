import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required String name,
    required DateTime birthdate,
    required String bodytype,
    required String gender,
    required double height,

  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}