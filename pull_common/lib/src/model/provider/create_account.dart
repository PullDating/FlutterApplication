
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_common/src/model/entity/profile.dart';


class accountCreationNotifier extends StateNotifier<Profile>{
  accountCreationNotifier() : super(Profile());

  void setName(String name){
    print("running setName function");
    state = state.copyWith(name: name);
  }

  String? getName(){
    return state.name;
  }

  void addImagePath(String imagepath,int index){
    state.imagesPaths.insert(index, imagepath);
  }

  String? getPathAtIndex(int index){
    return state.imagesPaths.elementAt(index);
  }

  void deleteAtIndex(int index){
    state.imagesPaths.removeAt(index);
  }

}

final accountCreationProvider = StateNotifierProvider<accountCreationNotifier,Profile>((ref) {
  return accountCreationNotifier();
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