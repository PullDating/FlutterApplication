
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/profile.dart';


class accountCreationNotifier extends StateNotifier<Profile>{
  accountCreationNotifier() : super(Profile());

  increase() => state = state.copyWith(name: state.name);

}

final accountCreationProfile = StateProvider((ref) => Profile(
  name: "default",
  birthdate: DateTime.now(),
  bodytype: "average",
  gender: "male",
  height: 175.4,

));