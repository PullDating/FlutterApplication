// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Profile _$$_ProfileFromJson(Map<String, dynamic> json) => _$_Profile(
      name: json['name'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      bodytype: json['bodytype'] as String?,
      gender: json['gender'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      datinggoal: json['datinggoal'] as String?,
      biography: json['biography'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$_ProfileToJson(_$_Profile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthdate': instance.birthdate?.toIso8601String(),
      'bodytype': instance.bodytype,
      'gender': instance.gender,
      'height': instance.height,
      'datinggoal': instance.datinggoal,
      'biography': instance.biography,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
