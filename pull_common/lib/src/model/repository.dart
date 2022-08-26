import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pull_common/pull_common.dart';
import 'package:pull_common/src/model/filters.dart';
import 'package:pull_common/src/model/entity/auth_response.dart';
import 'package:pull_common/src/model/exception/response_exception.dart';
import 'package:pull_common/src/model/provider/config.dart';
import 'package:pull_common/src/model/provider/match_stream.dart';
import 'package:riverpod/riverpod.dart';

/// Using a [Provider] for access to [http.Client] allows easy overriding during tests, if necessary
final httpClientProvider = Provider<http.Client>((_) => http.Client());

/// Repository for the Pull API
class PullRepository {
  PullRepository(this._read);

  // A [Reader] allows the API to read other providers, like to get API tokens
  final Reader _read;

  /// Derive an auth header from [authTokenProvider]
  Map<String, String> get _authHeader {
    final token = _read(authTokenProvider);
    if(token != null){
      return {"Authorization" : 'Bearer $token'};
    }else{
      throw Exception("couldn't retrieve the Authorization Token");
    }
  }


  /// Get default headers for API requests
  Map<String, String> get _headers {
    return {..._authHeader, 'Content-Type': 'application/json'};
  }

  Map<String, String> get _uuid {
    final uuid = _read(UUIDProvider);
    if(uuid != null){
      return {"uuid" : uuid};
    } else {
      throw Exception("Couldn't get the uuid");
    }
  }

  /// Get the HTTP client
  http.Client get _client => _read(httpClientProvider);

  /// Perform an (authenticated, if possible) GET request
  Future<Map<String, dynamic>> _get(Uri uri) async {
    final response = await _client.get(uri, headers: _headers);

    if (!response.statusCode.isOk) {
      throw ResponseException(response.statusCode, message: response.body);
    }

    return json.decode(response.body);
  }

  /// Perform an (authenticated, if possible) POST request with optional body
  Future<Map<String, dynamic>> _post(Uri uri, {Object? body}) async {
    final response = await _client.post(uri, headers: _headers, body: json.encode(body));


    if (!response.statusCode.isOk) {
      throw ResponseException(response.statusCode, message: response.body);
    }

    return json.decode(response.body);
  }

  /// Get an auth token from the Pull API and update the [networkAuthTokenProvider]'s state
  Future<AuthResponse> authenticate(AuthRequest authRequest) async {
    final result = AuthResponse.fromJson(await _post(authUri, body: authRequest.toJson()));
    if (result.userExists) {
      _read(networkAuthTokenProvider.notifier).state = result.token;
    }
    return result;
  }

  /// List the next potential matches in the card stack
  void nextMatches() async {
    final pageSize = _read(matchPageSizeProvider);
    final matchList = ((await _get(nextMatchesUri.replace(query: 'page_size=$pageSize')))['results'] as List).map((e) => Match.fromJson(e));

    //final matchList = (json.decode(await _get(nextMatchesUri.replace(query: 'page_size=$pageSize'))) as List).map((e) => Match.fromJson(e));

    _read(activeRefreshProvider.notifier).state = false;
    _read(matchStreamControllerProvider).add(matchList);
  }

  //the return is true if a profile already exists, false if a profile doesn't exist.
  Future<bool> loginRequest(String idToken, String phone) async {
    var request = http.Request('GET', loginUri);
    request.headers.addAll({"id" : idToken, "phone" : phone});
    var streamedResponse = await request.send().timeout(const Duration(seconds: 5));
    var response = await http.Response.fromStream(streamedResponse);
    if(response.statusCode == 200){
      print("Success");
      //TODO decode response to get the uuid and token fields.
      //var pdfText= await json.decode(json.encode(response.databody);
      final Map parsed = json.decode(response.body);
      print("response uuid: " + parsed['uuid']);
      print("response token " + parsed['token']);
      print("state: "  + parsed['state'].toString());
      //TODO set the returned uuid and auth token in hive.
      var Box = await Hive.openBox(kSettingsBox);
      Box.put(kSettingsApiToken,parsed['token']);
      Box.put(kSettingsUUID,parsed['uuid']);
      if(parsed['state'] == 0){
        return false;
      } else {
        return true;
      }
    }else{
      print("Something's wrong");
      print(response);
      throw Exception('Login attempt failed.');
    }
  }

  Future<Filters> getFilterRequest() async {
    Map<String,String> headers = {};
    headers.addAll(_authHeader);
    headers.addAll(_uuid);

    http.Response response = await http.get(filterUri, headers: headers);

    if(response.statusCode == 200){
      print('valid response code');
      print(jsonDecode(response.body));
      Filters filters = Filters.fromJson(jsonDecode(response.body));
      //print(filters.obese);
      return filters;
    } else {
      print("Error trying to get filters.");
      throw Exception("Error trying to get filters from server");
    }
  }

  Future<void> updateFilterRequest(Filters filters) async {
    Map<String,String> headers = {};
    headers.addAll(_authHeader);
    headers.addAll(_uuid);
    headers.addAll({"content-type" : "application/json"});
    var response = await http.put(
      filterUri,
      headers: headers,
      body: jsonEncode(filters.toJson())
    );
    if(response.statusCode == 200){
      return;
    } else {
      throw Exception("Updating filters to the server failed.");
    }
  }


  Future<void> createFilterRequest(Filters filters) async {
    //calculate the correct date values based on the inputted ages.
    //DateTime currentDate = DateTime.now();
    //DateTime minBirthDate = DateTime(currentDate.year - filters.upperAge, currentDate.month, currentDate.day);
    //DateTime maxBirthDate = DateTime(currentDate.year - filters.lowerAge, currentDate.month, currentDate.day);

    Map<String,String> headers = {};
    headers.addAll(_authHeader);
    headers.addAll(_uuid);
    headers.addAll({"content-type" : "application/json"});

    //create the request.
    var response = await http.post(
        filterUri,
        body: jsonEncode(<String,String>
        {
          "minAge" : filters.lowerAge.toString(),
          "maxAge" : filters.upperAge.toString(),
          "minHeight" : filters.lowerHeight.toString(),
          "maxHeight" : filters.upperHeight.toString(),
          "genderMan" : filters.menChecked.toString(),
          "genderWoman" : filters.womenChecked.toString(),
          "genderNonBinary" : filters.nonBinaryChecked.toString(),
          "btLean" : filters.lean.toString(),
          "btAverage" : filters.average.toString(),
          "btMuscular" : filters.muscular.toString(),
          "btHeavy" : filters.heavy.toString(),
          "btObese" : filters.obese.toString(),
          "maxDistance" : filters.maxDistance.toString(),
        }
      ),
      headers: headers
    );

    //interpret the response.
    if(response.statusCode == 200){
      print("Success");
      final Map parsed = json.decode(response.body);
      print(parsed['message']);
      return;
    }else{
      print("Something's wrong");
      print(response);
      throw Exception("Error sending filter information to the server.");
      return;
    }
  }

  //use a get request to get the file from the presigned url.
  Future<File> _fileFromImageUrl(String presignedUrl,String filename) async {
    print("got into _fileFromImageUrl");
    try {
      Uri presignedUri = Uri.parse(presignedUrl);
      final response = await http.get(presignedUri);
      final documentDirectory = await getApplicationDocumentsDirectory();
      final file = File(join(documentDirectory.path, filename));
      file.writeAsBytesSync(response.bodyBytes);
      return file;
    } catch (e){
      print(e);
      throw Exception("Couldn't get the file from the url given.");
    }
  }

  //takes in the imagePath from a profile get request in this format
  /*
  {
    "0": "https://minio.dev.pull.dating/nanortheast/2022-08-18T08%3A27%3A52.668-04%3A002c50be864dcccc3c1a4e?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=stomp3574%2F20220820%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220820T011205Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=bcfefda58d5ea34330bbbce2d6bc8e5b5178704301feadca04e7644d1eb1296c",
    "1": "https://minio.dev.pull.dating/nanortheast/2022-08-18T08%3A27%3A53.297-04%3A003c8b6ac16dd8f9c760d0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=stomp3574%2F20220820%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220820T011205Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=9582919207ce2eaa964482bb7a200f5c4fd95c96032d229c008cf334715c0565",
    "2": "https://minio.dev.pull.dating/nanortheast/2022-08-18T08%3A27%3A54.162-04%3A0054476da8913d18a28e1a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=stomp3574%2F20220820%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20220820T011205Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=cf78158d0164cd96f4ce7f03915638f3c21b54ba27dc072be273515ad8aa1788",
    "bucket": "nanortheast"
   }
   */
  //then it parses it to return a list of files.
  Future<List<File>> _filesFromImagePaths(Map<String,dynamic> imagePath) async {
    print("got into filesFromImagePaths");
    //print("image Path" + imagePath.toString());
    imagePath.remove('bucket');
    int length = imagePath.keys.length;
    print("number of presigned urls to get: ${length}");
    List<File> files = [];

    for(String element in imagePath.keys){
      print("looking at a presigned url...");
      //for each numbered element, add it to the list.
      try{
        await _fileFromImageUrl(imagePath[element]!,'profileImage${element}').then((newfile) => {
          print('adding element: ${element}'),
          files.add(newfile),
        });
      }catch(e){
        print(e);
        throw Exception("Couldn't get _fileFromImageUrl");
      }
    }
    return files;
  }

  //sets the profile images provder and the account creation provider with the relevant information
  Future<void> getProfile(WidgetRef ref) async {
    Map<String,String> headers = {};
    headers.addAll(_authHeader);
    headers.addAll(_uuid);
    http.Response response = await http.get(profileUri, headers: headers);

    if(response.statusCode == 200){
      print('valid response code');
      var json = jsonDecode(response.body);
      print(json);
      print("name");
      print(json['name']);

      //print("coordinates");
      var coordinates = json['lastLocation']['coordinates'];
      //print(coordinates);
      //create a profile object using the values.

      //convert the birthDates to ages
      print("attemping to parse the birthdate");
      DateTime birthdate = DateTime.parse(json['birthDate']);
      print("attemping to create the profile from json");
      Profile profile = Profile(
        name: json['name'],
        birthdate: birthdate,
        bodytype: json['bodyType'],
        gender: json['gender'],
        height: double.parse(json['height'].toString()),
        datinggoal: json['datingGoal'],
        biography: json['biography'],
        latitude: double.parse(coordinates[0].toString()),
        longitude: double.parse(coordinates[1].toString()),
      );
      print("created profile from json");
      ref.read(AccountCreationProvider.notifier).setProfile(profile);

      //update the min an max values

      try{
        await getPhotoLimits(ref);
      }catch (e) {
        print("error getting photo limits: ${e.toString()}");
        throw Exception("Couldn't get the photo limits");
      }

      try {
        List<File?> images = await _filesFromImagePaths(json['imagePath']);
        print("images.length ${images.length}");
        if(images.length < ref.read(ProfilePhotosProvider.notifier).getMin() || images.length > ref.read(ProfilePhotosProvider.notifier).getMax()){
          throw Exception('The server returned an invalid number of images. You may need to update the min and max profile photos first');
        }

        //update the images.
        ref.read(ProfilePhotosProvider.notifier).setImages(images);
        //update the number of images
        ref.read(ProfilePhotosProvider.notifier).setNumFilled(images.length);
        //update numfilled.
        ref.read(ProfilePhotosProvider.notifier).setMandatoryFilled(true);

      } catch (e) {
        print("problem getting the images: ${e.toString()}");
        throw Exception("problem getting the images for profile.");
      }
    } else {
      print("Error trying to get filters.");
      throw Exception("Error trying to get filters from server");
    }
  }

  Future<void> createProfile() async {
    //create a multipart form request (needed because we are using files)
    var request = http.MultipartRequest('POST', profileUri);
    //get the auth headers.
    //TODO fix this, right now it only returns "demo token" which is wrong.
    //request.headers.addAll(await _authHeader);

    request.headers.addAll(_authHeader);

    //list to hold the files we'll upload
    List<http.MultipartFile> filestoupload = [];
    //get the number of images they actually selected.
    int numFilled = _read(ProfilePhotosProvider.notifier).getNumFilled();
    int min = _read(ProfilePhotosProvider.notifier).getMin();
    int max = _read(ProfilePhotosProvider.notifier).getMax();

    if(numFilled > max || numFilled < min){
      throw Exception("you cannot create a profile with an invalid number of photos");
    }

    //loop through the photos and add the image files.
    for(int i = 0 ; i < numFilled; i++){
      File tempfile = _read(ProfilePhotosProvider).images[i]!;
      http.MultipartFile multifile = await http.MultipartFile.fromPath('photos', tempfile.path);
      filestoupload.add(multifile);
    }
    //append the image files to the request.
    request.files.addAll(filestoupload);

    var uuid = _uuid;
    request.fields.addAll(uuid);

    String? name = _read(AccountCreationProvider.notifier).getName();
    if(name != null){
      request.fields['name']= name;
    }else{
      throw Exception("name was not provided.");
    }

    DateTime? birthDate = _read(AccountCreationProvider.notifier).getBirthDate();
    if(birthDate != null){
      request.fields['birthDate']= birthDate.toString();
    }else{
      throw Exception("birthDate was not provided.");
    }

    String? gender = _read(AccountCreationProvider.notifier).getGender();
    if(gender != null){
      request.fields['gender']= gender;
    }else{
      throw Exception("gender was not provided.");
    }

    double? height = _read(AccountCreationProvider.notifier).getHeight();
    if(height != null){
      request.fields['height'] = height.toString();
    }else{
      throw Exception("height was not provided.");
    }

    String? datingGoal = _read(AccountCreationProvider.notifier).getDatingGoal();
    if(datingGoal != null){
      request.fields['datingGoal'] = datingGoal;
    } else {
      throw Exception("datingGoal was not provided.");
    }

    String? biography = _read(AccountCreationProvider.notifier).getBiography();
    if(biography != null){
      request.fields['biography'] = biography;
    } else {
      throw Exception("biography was not provided.");
    }

    String? bodyType = _read(AccountCreationProvider.notifier).getBodyType();
    if(bodyType != null){
      request.fields['bodyType'] = bodyType;
    } else {
      throw Exception("bodyType was not provided");
    }

    double? longitude = _read(AccountCreationProvider.notifier).getLongitude();
    if(longitude != null){
      request.fields["longitude"] = longitude.toString();
    }else{
      throw Exception("longitude was not provided.");
    }

    double? latitude = _read(AccountCreationProvider.notifier).getLatitidue();
    if(latitude != null){
      request.fields['latitude'] = latitude.toString();
    }

    try {
      var response = await request.send().timeout(const Duration(seconds: 3));
      if(response.statusCode == 200){
        print("Success");
      }else{
        print("Something wrong");
      }
    } on TimeoutException catch (e) {
      print('Timeout');
      print(e);
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  //TODO implement the functionality to call based on the reorder_photos, add_photos, and delete_photos.
  Future<void> updateProfile(WidgetRef ref, Profile newprofile, ProfileImages newprofileimages, List<int> change_photos) async {
    //TODO rework this to just use change photos instead of all 3 of them.

    var request = http.MultipartRequest('PUT', profileUri);
    request.headers.addAll(_authHeader);

    //list to hold the files we'll upload
    List<http.MultipartFile> filestoupload = [];
    //get the number of images they actually selected.
    int numFilled = newprofileimages.numFilled;
    int min = newprofileimages.min;
    int max = newprofileimages.max;

    if(numFilled > max || numFilled < min){
      throw Exception("you cannot create a profile with an invalid number of photos");
    }

    try{

      print("numfilled: ${numFilled}");
      print("change_photos length: ${change_photos.length}");
      for(int i = 0; i < numFilled; i++){
        //if at position i, there is a -1 in the change_photos, do we want to upload it.
        if(change_photos[i] == -1){
          File tempfile = newprofileimages.images[i]!;
          http.MultipartFile multifile = await http.MultipartFile.fromPath('photos', tempfile.path);
          filestoupload.add(multifile);
        }
      }
      //append the image files to the request.
      request.files.addAll(filestoupload);
    } catch (e){
      print(e);
      throw Exception("problem adding the images to the put profile request.");
    }
    //add the uuid to the request
    //todo modify the endpoint to accept the uuid in the header instead of in the body.
    var uuid = _uuid;
    request.fields.addAll(uuid);

    //add the reorderphotos functionality. Convert the list to json first.
    Map<String, String> changePhotoJson = {};
    for(int i = 0; i < change_photos.length; i++){
       changePhotoJson.addAll({"\"${i}\"" : "\"${change_photos.elementAt(i)}\""});
    }
    changePhotoJson;

    print("change Photo Json string");
    print(changePhotoJson);

    request.fields.addAll({"change_photos" : changePhotoJson.toString()});

    String? gender = newprofile.gender;
    if(gender != null){
      request.fields['gender']= gender;
    }else{
      throw Exception("gender was not provided.");
    }

    String? datingGoal = newprofile.datinggoal;
    if(datingGoal != null){
      request.fields['datingGoal'] = datingGoal;
    } else {
      throw Exception("datingGoal was not provided.");
    }

    String? biography = newprofile.biography;
    if(biography != null){
      request.fields['biography'] = biography;
    } else {
      throw Exception("biography was not provided.");
    }

    String? bodyType = newprofile.bodytype;
    if(bodyType != null){
      request.fields['bodyType'] = bodyType;
    } else {
      throw Exception("bodyType was not provided");
    }

    try {
      var response = await request.send().timeout(const Duration(seconds: 3));
      if(response.statusCode == 200){
        print("Success");
      }else{
        print("Something wrong");
      }
    } on TimeoutException catch (e) {
      print('Timeout');
      print(e);
    } on Error catch (e) {
      print('Error: $e');
    }

  }

  Future<void> getPhotoLimits(WidgetRef ref) async {
    print("got into getPhotoLimits");
    var url = profilePhotoLimitsUri;
    var decoded;
    var response = await http.get(url).timeout(const Duration(seconds: 3));
    if(response.statusCode == 200){
      print("Success");
      decoded = json.decode(response.body);
      print("attemping to set state with new photo limits");
      ref.read(ProfilePhotosProvider.notifier).setMax(decoded['maxProfilePhotos']);
      ref.read(ProfilePhotosProvider.notifier).setMin(decoded['minProfilePhotos']);
      ref.read(ProfilePhotosProvider.notifier).setImages(List<File?>.filled(ref.read(ProfilePhotosProvider.notifier).getMax(), null));
    } else {
      throw Exception("The status code on getting photos limits was not 200");
    }
  }
}

extension _StatusCode on int {
  bool get isOk => this >= 200 && this <= 300;
}
