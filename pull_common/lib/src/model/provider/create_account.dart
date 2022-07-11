import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/profile.dart';
import 'package:location/location.dart';

class AccountCreationNotifier extends StateNotifier<Profile> {
  AccountCreationNotifier() : super(Profile());

  void setName(String name) {
    print("running setName function");
    state = state.copyWith(name: name);
  }

  String? getName() {
    return state.name;
  }

  void addImagePath(String imagepath, int index) {
    List<String> paths = state.imagesPaths;
    state = state.copyWith(imagesPaths: paths);
  }

  String? getPathAtIndex(int index) {
    return state.imagesPaths.elementAt(index);
  }

  double? getHeight() {
    return state.height;
  }

  void deleteAtIndex(int index) {
    state.imagesPaths.removeAt(index);
  }

  void setBirthDate(DateTime date) {
    state = state.copyWith(birthdate: date);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setHeight(double height) {
    state = state.copyWith(height: height);
  }

  void setBodyType(String bodytype) {
    state = state.copyWith(bodytype: bodytype);
  }

  void setDatingGoal(String datinggoal) {
    state = state.copyWith(datinggoal: datinggoal);
  }

  void setBiography(String biography) {
    state = state.copyWith(biography: biography);
  }

  DateTime? getBirthDate() {
    return state.birthdate;
  }

  double? getLatitidue(){
    return state.latitude;
  }

  void setLatitude(double latitude) {
    state = state.copyWith(latitude: latitude);
  }

  double? getLongitude(){
    return state.longitude;
  }

  void setLongitude(double longitude) {
    state = state.copyWith(longitude: longitude);
  }
}

final AccountCreationProvider =
    StateNotifierProvider<AccountCreationNotifier, Profile>((ref) {
  return AccountCreationNotifier();
});

/*
final accountCreationProfile = StateProvider((ref) => Profile(
  name: "default",
  birthdate: DateTime.now(),
  bodytype: "average",
  gender: "male",
  height: 175.4,

));
 */
