// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'response_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ResponseException {
  int get code => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResponseExceptionCopyWith<ResponseException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResponseExceptionCopyWith<$Res> {
  factory $ResponseExceptionCopyWith(
          ResponseException value, $Res Function(ResponseException) then) =
      _$ResponseExceptionCopyWithImpl<$Res>;
  $Res call({int code, String? message});
}

/// @nodoc
class _$ResponseExceptionCopyWithImpl<$Res>
    implements $ResponseExceptionCopyWith<$Res> {
  _$ResponseExceptionCopyWithImpl(this._value, this._then);

  final ResponseException _value;
  // ignore: unused_field
  final $Res Function(ResponseException) _then;

  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_ResponseExceptionCopyWith<$Res>
    implements $ResponseExceptionCopyWith<$Res> {
  factory _$$_ResponseExceptionCopyWith(_$_ResponseException value,
          $Res Function(_$_ResponseException) then) =
      __$$_ResponseExceptionCopyWithImpl<$Res>;
  @override
  $Res call({int code, String? message});
}

/// @nodoc
class __$$_ResponseExceptionCopyWithImpl<$Res>
    extends _$ResponseExceptionCopyWithImpl<$Res>
    implements _$$_ResponseExceptionCopyWith<$Res> {
  __$$_ResponseExceptionCopyWithImpl(
      _$_ResponseException _value, $Res Function(_$_ResponseException) _then)
      : super(_value, (v) => _then(v as _$_ResponseException));

  @override
  _$_ResponseException get _value => super._value as _$_ResponseException;

  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
  }) {
    return _then(_$_ResponseException(
      code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ResponseException implements _ResponseException {
  const _$_ResponseException(this.code, {this.message});

  @override
  final int code;
  @override
  final String? message;

  @override
  String toString() {
    return 'ResponseException(code: $code, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ResponseException &&
            const DeepCollectionEquality().equals(other.code, code) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(code),
      const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$_ResponseExceptionCopyWith<_$_ResponseException> get copyWith =>
      __$$_ResponseExceptionCopyWithImpl<_$_ResponseException>(
          this, _$identity);
}

abstract class _ResponseException implements ResponseException {
  const factory _ResponseException(final int code, {final String? message}) =
      _$_ResponseException;

  @override
  int get code;
  @override
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$_ResponseExceptionCopyWith<_$_ResponseException> get copyWith =>
      throw _privateConstructorUsedError;
}
