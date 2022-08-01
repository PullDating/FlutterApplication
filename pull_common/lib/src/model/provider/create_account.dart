import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/profile.dart';
import 'package:location/location.dart';


class ProfileImages{
  const ProfileImages({
    required this.min,
    required this.max,
    required this.images,
    required this.numFilled,
    required this.mandatoryFilled,
  });

  final int min;
  final int max;
  final List<File?> images;
  final int numFilled;
  final bool mandatoryFilled;

  ProfileImages copyWith({List<File?>? images, int? min, int? max, int? numFilled, bool? mandatoryFilled}){
    return ProfileImages(
      min: min ?? this.min,
      max: max ?? this.max,
      images: images ?? this.images,
      numFilled: numFilled ?? this.numFilled,
      mandatoryFilled: mandatoryFilled ?? this.mandatoryFilled,
    );
  }

}

final ProfilePhotosProvider = StateNotifierProvider<ProfilePhotosNotifier, ProfileImages>((ref) {
  return ProfilePhotosNotifier();
});

class ProfilePhotosNotifier extends StateNotifier<ProfileImages> {
  ProfilePhotosNotifier() : super(ProfileImages(max: 100, min: 0, images: [], numFilled: 0, mandatoryFilled: false));

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



  int getNumFilled(){
    return state.numFilled;
  }

  void setImage(File image, int index){
    List<File?> tempimages = state.images;
    int tempnumfilled = state.numFilled;
    bool tempmandatory = state.mandatoryFilled;
    if(index < state.max && index >= 0){
      tempimages[index] = image;
      tempnumfilled++;
      if(tempnumfilled >= state.min){
        tempmandatory = true;
      }
      state = state.copyWith(
          images: tempimages,
          numFilled: tempnumfilled,
          mandatoryFilled: tempmandatory
      );
    } else {
      throw "The index you tried to replace is out of range";
    }
  }

  void removeImage(int index){
    if(index < state.max && index >= 0){

      List<File?> temp = state.images;
      int tempfilled = state.numFilled;
      for(int i = index; i < state.max-1; i++){
        //print("index in loop:" + i.toString());
        temp[i] = temp[i+1];
      }
      temp[state.max-1] = null;
      tempfilled--;

      bool mandatory = state.mandatoryFilled;
      if(tempfilled < state.min){
        mandatory = false;
      }

      state = state.copyWith(images: temp, numFilled: tempfilled, mandatoryFilled: mandatory);

    } else {
      throw "The index you tried to replace is out of range";
    }
  }


}


class AccountCreationNotifier extends StateNotifier<Profile> {
  AccountCreationNotifier() : super(Profile());

  String? getGender(){
    return state.gender;
  }

  String? getDatingGoal(){
    return state.datinggoal;
  }

  String? getBiography(){
    return state.biography;
  }

  String? getBodyType(){
    return state.bodytype;
  }

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
