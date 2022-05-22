import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/model/config/constants.dart';

final _useDarkThemeStreamProvider = StreamProvider<bool>((ref) async* {
  final settings = ref.watch(settingsProvider);
  if (settings != null) {
    yield settings.get(kSettingsUseDarkTheme) as bool;
    yield* settings.watch(key: kSettingsUseDarkTheme).map((event) => event.value as bool);
  } else {
    yield false;
  }
});

/// Whether to use the dark theme
final useDarkThemeProvider = Provider((ref) {
  return ref.watch(_useDarkThemeStreamProvider).valueOrNull ?? false;
});
