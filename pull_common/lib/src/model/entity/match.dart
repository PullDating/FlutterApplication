import 'dart:io';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:pull_common/src/model/entity/media.dart';

part 'match.freezed.dart';
part 'match.g.dart';

/// A potential match or matched user. To contain only public profile information
@freezed
@Collection()
class Match with _$Match {
  const factory Match({
      required int id,
      required String displayName,
      required int age,
      String? bodyType,
      @Default('') String bio,
      @Default([]) List<Media> media,
      //@Default([]) List<Image> media,
      String? pronouns,
      String? gender,
      @Default([]) List<String> interests
  }) = _Match;

  factory Match.fromJson(Map<String, Object?> json) => _$MatchFromJson(json);
}

