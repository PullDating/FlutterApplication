import 'dart:io';
import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:pull_common/src/model/entity/media.dart';

import '../../../pull_common.dart';

part 'match.freezed.dart';
part 'match.g.dart';

List<Media> getMediaFromProfileImages(ProfileImages profileImages){
  //for each item in the list of images, find the path and add to a list of uris
  List<Media> values = [];
  try {
    for (int i = 0; i < profileImages.images.length; i++) {
      print(profileImages.images[i]!.path);
      values.add(Media(
        //pass in the path to the file
          uri: Uri.file(profileImages.images[i]!.path)
      ));
    }
  } catch (e){
    print(e);
    throw Exception("unable to load the profile photo media.");
  }
  //print("values: ${values}");
  return values;
}
/// A potential match or matched user. To contain only public profile information
@freezed
@Collection()
class Match with _$Match {
  const factory Match({
      required String uuid,
      required int distanceInMeters,
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

