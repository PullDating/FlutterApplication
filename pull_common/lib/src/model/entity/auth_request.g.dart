// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Phone _$$_PhoneFromJson(Map<String, dynamic> json) => _$_Phone(
      json['phone'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_PhoneToJson(_$_Phone instance) => <String, dynamic>{
      'phone': instance.phone,
      'runtimeType': instance.$type,
    };

_$_EmailPassword _$$_EmailPasswordFromJson(Map<String, dynamic> json) =>
    _$_EmailPassword(
      json['email'] as String,
      json['password'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$_EmailPasswordToJson(_$_EmailPassword instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'runtimeType': instance.$type,
    };
