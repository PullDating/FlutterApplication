// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return _Profile.fromJson(json);
}

/// @nodoc
mixin _$Profile {
  String get name => throw _privateConstructorUsedError;
  DateTime get birthdate => throw _privateConstructorUsedError;
  String get bodytype => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProfileCopyWith<Profile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) then) =
      _$ProfileCopyWithImpl<$Res>;
  $Res call(
      {String name,
      DateTime birthdate,
      String bodytype,
      String gender,
      double height});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res> implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._value, this._then);

  final Profile _value;
  // ignore: unused_field
  final $Res Function(Profile) _then;

  @override
  $Res call({
    Object? name = freezed,
    Object? birthdate = freezed,
    Object? bodytype = freezed,
    Object? gender = freezed,
    Object? height = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthdate: birthdate == freezed
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bodytype: bodytype == freezed
          ? _value.bodytype
          : bodytype // ignore: cast_nullable_to_non_nullable
              as String,
      gender: gender == freezed
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      height: height == freezed
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$$_ProfileCopyWith(
          _$_Profile value, $Res Function(_$_Profile) then) =
      __$$_ProfileCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      DateTime birthdate,
      String bodytype,
      String gender,
      double height});
}

/// @nodoc
class __$$_ProfileCopyWithImpl<$Res> extends _$ProfileCopyWithImpl<$Res>
    implements _$$_ProfileCopyWith<$Res> {
  __$$_ProfileCopyWithImpl(_$_Profile _value, $Res Function(_$_Profile) _then)
      : super(_value, (v) => _then(v as _$_Profile));

  @override
  _$_Profile get _value => super._value as _$_Profile;

  @override
  $Res call({
    Object? name = freezed,
    Object? birthdate = freezed,
    Object? bodytype = freezed,
    Object? gender = freezed,
    Object? height = freezed,
  }) {
    return _then(_$_Profile(
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      birthdate: birthdate == freezed
          ? _value.birthdate
          : birthdate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bodytype: bodytype == freezed
          ? _value.bodytype
          : bodytype // ignore: cast_nullable_to_non_nullable
              as String,
      gender: gender == freezed
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      height: height == freezed
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Profile implements _Profile {
  const _$_Profile(
      {required this.name,
      required this.birthdate,
      required this.bodytype,
      required this.gender,
      required this.height});

  factory _$_Profile.fromJson(Map<String, dynamic> json) =>
      _$$_ProfileFromJson(json);

  @override
  final String name;
  @override
  final DateTime birthdate;
  @override
  final String bodytype;
  @override
  final String gender;
  @override
  final double height;

  @override
  String toString() {
    return 'Profile(name: $name, birthdate: $birthdate, bodytype: $bodytype, gender: $gender, height: $height)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Profile &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.birthdate, birthdate) &&
            const DeepCollectionEquality().equals(other.bodytype, bodytype) &&
            const DeepCollectionEquality().equals(other.gender, gender) &&
            const DeepCollectionEquality().equals(other.height, height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(birthdate),
      const DeepCollectionEquality().hash(bodytype),
      const DeepCollectionEquality().hash(gender),
      const DeepCollectionEquality().hash(height));

  @JsonKey(ignore: true)
  @override
  _$$_ProfileCopyWith<_$_Profile> get copyWith =>
      __$$_ProfileCopyWithImpl<_$_Profile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ProfileToJson(this);
  }
}

abstract class _Profile implements Profile {
  const factory _Profile(
      {required final String name,
      required final DateTime birthdate,
      required final String bodytype,
      required final String gender,
      required final double height}) = _$_Profile;

  factory _Profile.fromJson(Map<String, dynamic> json) = _$_Profile.fromJson;

  @override
  String get name => throw _privateConstructorUsedError;
  @override
  DateTime get birthdate => throw _privateConstructorUsedError;
  @override
  String get bodytype => throw _privateConstructorUsedError;
  @override
  String get gender => throw _privateConstructorUsedError;
  @override
  double get height => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileCopyWith<_$_Profile> get copyWith =>
      throw _privateConstructorUsedError;
}
