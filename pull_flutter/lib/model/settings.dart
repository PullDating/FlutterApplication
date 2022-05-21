import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_flutter/model/config/constants.dart';

/// Whether to use the dark theme
final useDarkThemeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider)?.get(kSettingsUseDarkTheme);
});
