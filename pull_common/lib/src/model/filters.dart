class Filters{
  bool menChecked = false;
  bool womenChecked = false;
  bool nonBinaryChecked = false;
  int lowerAge = 18;
  int upperAge = 100;
  int lowerHeight = 55;
  int upperHeight = 275;
  int maxDistance = 15;

  bool obese = true;
  bool heavy = true;
  bool muscular = true;
  bool average = true;
  bool lean = true;

  Filters({
    required this.menChecked,
    required this.womenChecked,
    required this.nonBinaryChecked,
    required this.lowerAge,
    required this.upperAge,
    required this.lowerHeight,
    required this.upperHeight,
    required this.maxDistance,
    required this.obese,
    required this.heavy,
    required this.muscular,
    required this.average,
    required this.lean,
  });

   Filters.basic({
     menChecked: false,
     womenChecked: false,
     nonBinaryChecked: false,
     lowerAge: 18,
     upperAge: 100,
     lowerHeight: 55,
     upperHeight: 275,
     maxDistance: 15,
     obese: true,
     heavy: true,
     muscular: true,
     average: true,
     lean: true,
   });


  factory Filters.fromJson(Map<String,dynamic> json){

    print(json);

    print("Attempting to get the Filters from json");

    //convert the birthDates to ages
    DateTime minBirthDate = DateTime.parse(json['minBirthDate'] as String);
    DateTime maxBirthDate = DateTime.parse(json['maxBirthDate'] as String);

    print("minBirthDate: " + minBirthDate.toString());
    print("maxBirthDate: " + maxBirthDate.toString());

    int upperAge = ((DateTime.now().difference(minBirthDate).inDays)/365.26).truncate();
    int lowerAge = ((DateTime.now().difference(maxBirthDate).inDays)/365.26).truncate();

    print("upperAge: " + upperAge.toString());
    print("lowerAge: " + lowerAge.toString());

    //print("type of json['maxDistance]: " + json['maxDistance'].runtimeType.toString());

    return Filters(
      maxDistance: int.parse(json['maxDistance']),
      menChecked: StringtoBool(json['genderMan']),
      womenChecked: StringtoBool(json['genderWoman']),
      nonBinaryChecked: StringtoBool(json['genderNonBinary']),
      lowerAge: lowerAge,
      upperAge: upperAge,
      lowerHeight: int.parse(json['minHeight']),
      upperHeight: int.parse(json['maxHeight']),
      obese: StringtoBool(json['btObese']),
      heavy: StringtoBool(json['btHeavy']),
      muscular: StringtoBool(json['btMuscular']),
      average: StringtoBool(json['btAverage']),
      lean: StringtoBool(json['btLean']),
    );
  }

  Map<String,dynamic> toJson(){
    return <String,String>{
      'maxDistance' : this.maxDistance.toString(),
      'genderMan' : this.menChecked.toString(),
      'genderWoman' : this.womenChecked.toString(),
      'genderNonBinary' : this.nonBinaryChecked.toString(),
      'lowerAge' : this.lowerAge.toString(),
      'upperAge' : this.upperAge.toString(),
      'minHeight' : this.lowerHeight.toString(),
      'maxHeight' : this.upperHeight.toString(),
      'btObese' : this.obese.toString(),
      'btHeavy' : this.heavy.toString(),
      'btMuscular' : this.muscular.toString(),
      'btAverage' : this.average.toString(),
      'btLean' : this.lean.toString(),
    };
  }

}

bool StringtoBool(String input){
  String temp = input.toLowerCase();
  if(temp == 'true'){
    return true;
  } else if(temp == 'false') {
    return false;
  } else {
    throw Exception("invalid input to boolean conversion.");
  }
}