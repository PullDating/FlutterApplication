// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Match _$$_MatchFromJson(Map<String, dynamic> json) => _$_Match(
      uuid: json['uuid'] as String,
      distanceInMeters: json['distanceInMeters'] as int,
      displayName: json['displayName'] as String,
      age: json['age'] as int,
      bodyType: json['bodyType'] as String?,
      bio: json['bio'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pronouns: json['pronouns'] as String?,
      gender: json['gender'] as String?,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_MatchToJson(_$_Match instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'distanceInMeters': instance.distanceInMeters,
      'displayName': instance.displayName,
      'age': instance.age,
      'bodyType': instance.bodyType,
      'bio': instance.bio,
      'media': instance.media,
      'pronouns': instance.pronouns,
      'gender': instance.gender,
      'interests': instance.interests,
    };
