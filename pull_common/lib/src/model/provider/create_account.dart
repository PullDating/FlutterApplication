import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/profile.dart';
import 'package:location/location.dart';


class ProfileImages{
  const ProfileImages({
    required this.min,
    required this.max,
    required this.images
  });

  final int min;
  final int max;
  final List<File?> images;

  ProfileImages copyWith({List<File?>? images, int? min, int? max}){
    return ProfileImages(
      min: min ?? this.min,
      max: max ?? this.max,
      images: images ?? this.images,
    );
  }

}

final ProfilePhotosProvider = StateNotifierProvider<ProfilePhotosNotifier, ProfileImages>((ref) {
  return ProfilePhotosNotifier();
});

class ProfilePhotosNotifier extends StateNotifier<ProfileImages> {
  ProfilePhotosNotifier() : super(ProfileImages(max: 100, min: 0, images: []));

  void setImages(List<File?> images){
    state = state.copyWith(images: images);
  }

  void setMax(int max){
    state = state.copyWith(max: max);
  }

  void setMin(int min){
    state = state.copyWith(min: min);
  }

  int getMax(){
    return state.max;
  }

  int getMin(){
    return state.min;
  }

  void addImage(File image){

  }

  void replaceImage(int index, File image){
    if(index < state.max && index >= 0){
      List<File?> temp = state.images;
      temp[index] = image;
      state = state.copyWith(images: temp);
    } else {
      throw "The index you tried to replace is out of range";
    }
  }

  void removeImages(int index){
    if(index < state.max && index >= 0){
      List<File?> temp = state.images;
      temp[index] = null;
      state = state.copyWith(images: temp);
    } else {
      throw "The index you tried to replace is out of range";
    }
  }


}


class AccountCreationNotifier extends StateNotifier<Profile> {
  AccountCreationNotifier() : super(Profile());

  void setName(String name) {
    print("running setName function");
    state = state.copyWith(name: name);
  }

  String? getName() {
    return state.name;
  }

  double? getHeight() {
    return state.height;
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
