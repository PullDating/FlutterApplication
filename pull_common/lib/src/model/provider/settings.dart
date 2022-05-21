import 'package:hive/hive.dart';
import 'package:pull_common/src/model/config/constants.dart';
import 'package:pull_common/src/model/provider/local_data.dart';
import 'package:riverpod/riverpod.dart';

/// A provider that opens the settings Box
final _settingsFutureProvider = FutureProvider<Box>((ref) async {
  return await Hive.openBox(kSettingsBox);
});

/// A provider that waits until Hive is ready, then opens the settings box
final settingsFutureProvider = Provider<AsyncValue<Box>>((ref) {
  final hiveReady = ref.watch(hiveReadyProvider);
  return hiveReady ? ref.watch(_settingsFutureProvider) : AsyncValue.loading();
});

/// A provider that provides the settings box if it's available, otherwise null
final settingsProvider = Provider<Box?>((ref) => ref.watch(settingsFutureProvider).maybeWhen(orElse: () => null));
