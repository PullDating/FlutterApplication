import 'package:riverpod/riverpod.dart';

/// A provider that indicates when the Hive key-value store is ready
final hiveReadyProvider = StateProvider((ref) => false);
