import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';
part 'media.g.dart';

/// A potential match or matched user. To contain only public profile information
@freezed
class Media with _$Media {
  const factory Media({required Uri uri, String? blurHash}) = _Media;

  factory Media.fromJson(Map<String, Object?> json) => _$MediaFromJson(json);
}
