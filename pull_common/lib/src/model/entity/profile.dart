import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    String? name,
    DateTime? birthdate,
    String? bodytype,
    String? gender,
    double? height,
    @Default([]) List<String> imagesPaths,
    String? datinggoal,
    String? biography,

  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
}