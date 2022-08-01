import 'package:pull_common/src/model/config/constants.dart';
import 'package:pull_common/src/model/provider/settings.dart';
import 'package:riverpod/riverpod.dart';

/// The locally stored auth token
final storedAuthTokenProvider = Provider<String?>((ref) {
  return ref.watch(settingsProvider)?.get(kSettingsApiToken);
});

final storedUUIDProvider = Provider<String?>((ref) {
  return ref.watch(settingsProvider)?.get(kSettingsUUID);
});

/// The auth token fetched from the network
final networkAuthTokenProvider = StateProvider<String?>((_) => null);

/// Attempts to obtain the stored token first, falling back to obtaining a token from the network
final authTokenProvider = Provider<String?>((ref) {
  final storedAuthToken = ref.watch(storedAuthTokenProvider);
  final networkAuthToken = ref.watch(networkAuthTokenProvider);
  return storedAuthToken ?? networkAuthToken;
});

final UUIDProvider = Provider<String?>((ref){
  final storedUUID = ref.watch(storedUUIDProvider);
  if(storedUUID != null){
    return storedUUID;
  }else{
    throw("Couldn't find Stored UUID");
  }

});
