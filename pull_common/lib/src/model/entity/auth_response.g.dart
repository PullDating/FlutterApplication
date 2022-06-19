// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AuthResponse _$$_AuthResponseFromJson(Map<String, dynamic> json) =>
    _$_AuthResponse(
      userExists: json['user_exists'] as bool,
      token: json['token'] as String?,
      uuid: json['uuid'] as String?,
    );

Map<String, dynamic> _$$_AuthResponseToJson(_$_AuthResponse instance) =>
    <String, dynamic>{
      'user_exists': instance.userExists,
      'token': instance.token,
      'uuid': instance.uuid,
    };
