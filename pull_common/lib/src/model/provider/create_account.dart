
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/profile.dart';

final accountCreationProfile = StateProvider((ref) => Profile(
  name: "default",
  birthdate: DateTime.now(),
  bodytype: "average",
  gender: "male",
  height: 175.4,

));