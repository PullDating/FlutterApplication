// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Profile _$$_ProfileFromJson(Map<String, dynamic> json) => _$_Profile(
      name: json['name'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      bodytype: json['bodytype'] as String,
      gender: json['gender'] as String,
      height: (json['height'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ProfileToJson(_$_Profile instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birthdate': instance.birthdate.toIso8601String(),
      'bodytype': instance.bodytype,
      'gender': instance.gender,
      'height': instance.height,
    };
