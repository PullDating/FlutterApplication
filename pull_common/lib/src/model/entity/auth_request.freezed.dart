// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuthRequest _$AuthRequestFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'phone':
      return _Phone.fromJson(json);
    case 'emailPassword':
      return _EmailPassword.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AuthRequest',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AuthRequest {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phone,
    required TResult Function(String email, String password) emailPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String phone)? phone,
    TResult Function(String email, String password)? emailPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phone,
    TResult Function(String email, String password)? emailPassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Phone value) phone,
    required TResult Function(_EmailPassword value) emailPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Phone value)? phone,
    TResult Function(_EmailPassword value)? emailPassword,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Phone value)? phone,
    TResult Function(_EmailPassword value)? emailPassword,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthRequestCopyWith<$Res> {
  factory $AuthRequestCopyWith(
          AuthRequest value, $Res Function(AuthRequest) then) =
      _$AuthRequestCopyWithImpl<$Res>;
}

/// @nodoc
class _$AuthRequestCopyWithImpl<$Res> implements $AuthRequestCopyWith<$Res> {
  _$AuthRequestCopyWithImpl(this._value, this._then);

  final AuthRequest _value;
  // ignore: unused_field
  final $Res Function(AuthRequest) _then;
}

/// @nodoc
abstract class _$$_PhoneCopyWith<$Res> {
  factory _$$_PhoneCopyWith(_$_Phone value, $Res Function(_$_Phone) then) =
      __$$_PhoneCopyWithImpl<$Res>;
  $Res call({String phone});
}

/// @nodoc
class __$$_PhoneCopyWithImpl<$Res> extends _$AuthRequestCopyWithImpl<$Res>
    implements _$$_PhoneCopyWith<$Res> {
  __$$_PhoneCopyWithImpl(_$_Phone _value, $Res Function(_$_Phone) _then)
      : super(_value, (v) => _then(v as _$_Phone));

  @override
  _$_Phone get _value => super._value as _$_Phone;

  @override
  $Res call({
    Object? phone = freezed,
  }) {
    return _then(_$_Phone(
      phone == freezed
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Phone implements _Phone {
  const _$_Phone(this.phone, {final String? $type}) : $type = $type ?? 'phone';

  factory _$_Phone.fromJson(Map<String, dynamic> json) =>
      _$$_PhoneFromJson(json);

  @override
  final String phone;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthRequest.phone(phone: $phone)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Phone &&
            const DeepCollectionEquality().equals(other.phone, phone));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(phone));

  @JsonKey(ignore: true)
  @override
  _$$_PhoneCopyWith<_$_Phone> get copyWith =>
      __$$_PhoneCopyWithImpl<_$_Phone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phone,
    required TResult Function(String email, String password) emailPassword,
  }) {
    return phone(this.phone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String phone)? phone,
    TResult Function(String email, String password)? emailPassword,
  }) {
    return phone?.call(this.phone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phone,
    TResult Function(String email, String password)? emailPassword,
    required TResult orElse(),
  }) {
    if (phone != null) {
      return phone(this.phone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Phone value) phone,
    required TResult Function(_EmailPassword value) emailPassword,
  }) {
    return phone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Phone value)? phone,
    TResult Function(_EmailPassword value)? emailPassword,
  }) {
    return phone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Phone value)? phone,
    TResult Function(_EmailPassword value)? emailPassword,
    required TResult orElse(),
  }) {
    if (phone != null) {
      return phone(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_PhoneToJson(
      this,
    );
  }
}

abstract class _Phone implements AuthRequest {
  const factory _Phone(final String phone) = _$_Phone;

  factory _Phone.fromJson(Map<String, dynamic> json) = _$_Phone.fromJson;

  String get phone;
  @JsonKey(ignore: true)
  _$$_PhoneCopyWith<_$_Phone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_EmailPasswordCopyWith<$Res> {
  factory _$$_EmailPasswordCopyWith(
          _$_EmailPassword value, $Res Function(_$_EmailPassword) then) =
      __$$_EmailPasswordCopyWithImpl<$Res>;
  $Res call({String email, String password});
}

/// @nodoc
class __$$_EmailPasswordCopyWithImpl<$Res>
    extends _$AuthRequestCopyWithImpl<$Res>
    implements _$$_EmailPasswordCopyWith<$Res> {
  __$$_EmailPasswordCopyWithImpl(
      _$_EmailPassword _value, $Res Function(_$_EmailPassword) _then)
      : super(_value, (v) => _then(v as _$_EmailPassword));

  @override
  _$_EmailPassword get _value => super._value as _$_EmailPassword;

  @override
  $Res call({
    Object? email = freezed,
    Object? password = freezed,
  }) {
    return _then(_$_EmailPassword(
      email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_EmailPassword implements _EmailPassword {
  const _$_EmailPassword(this.email, this.password, {final String? $type})
      : $type = $type ?? 'emailPassword';

  factory _$_EmailPassword.fromJson(Map<String, dynamic> json) =>
      _$$_EmailPasswordFromJson(json);

  @override
  final String email;
  @override
  final String password;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AuthRequest.emailPassword(email: $email, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EmailPassword &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.password, password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(password));

  @JsonKey(ignore: true)
  @override
  _$$_EmailPasswordCopyWith<_$_EmailPassword> get copyWith =>
      __$$_EmailPasswordCopyWithImpl<_$_EmailPassword>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String phone) phone,
    required TResult Function(String email, String password) emailPassword,
  }) {
    return emailPassword(email, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String phone)? phone,
    TResult Function(String email, String password)? emailPassword,
  }) {
    return emailPassword?.call(email, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String phone)? phone,
    TResult Function(String email, String password)? emailPassword,
    required TResult orElse(),
  }) {
    if (emailPassword != null) {
      return emailPassword(email, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Phone value) phone,
    required TResult Function(_EmailPassword value) emailPassword,
  }) {
    return emailPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_Phone value)? phone,
    TResult Function(_EmailPassword value)? emailPassword,
  }) {
    return emailPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Phone value)? phone,
    TResult Function(_EmailPassword value)? emailPassword,
    required TResult orElse(),
  }) {
    if (emailPassword != null) {
      return emailPassword(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$_EmailPasswordToJson(
      this,
    );
  }
}

abstract class _EmailPassword implements AuthRequest {
  const factory _EmailPassword(final String email, final String password) =
      _$_EmailPassword;

  factory _EmailPassword.fromJson(Map<String, dynamic> json) =
      _$_EmailPassword.fromJson;

  String get email;
  String get password;
  @JsonKey(ignore: true)
  _$$_EmailPasswordCopyWith<_$_EmailPassword> get copyWith =>
      throw _privateConstructorUsedError;
}
