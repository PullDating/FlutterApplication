import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'dart:io';

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


  //TODO add the createFilterRequest
  Future<void> createFilterRequest(Filters filters) async {
    //calculate the correct date values based on the inputted ages.
    DateTime currentDate = DateTime.now();
    DateTime minBirthDate = DateTime(currentDate.year - filters.upperAge, currentDate.month, currentDate.day);
    DateTime maxBirthDate = DateTime(currentDate.year - filters.lowerAge, currentDate.month, currentDate.day);

    Map<String,String> headers = {};
    headers.addAll(_authHeader);
    headers.addAll(_uuid);
    headers.addAll({"content-type" : "application/json"});

    //create the request.
    var response = await http.post(
        filterUri,
        body: jsonEncode(<String,String>
        {
          "minBirthDate" : minBirthDate.toString(),
          "maxBirthDate" : maxBirthDate.toString(),
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

  /*
  Future<bool> updateFilterRequest(Filters filters) async {

    return false;
    //TODO calculate the minBirthDate and maxBirthDate from the filters input.
    DateTime? maxBirthDate = DateTime.now();
    DateTime? minBirthDate = DateTime.now();
    //TODO make sure that the correct format for date.tostring is used.
    var request = http.post(filterUri, body: jsonEncode(<String,String>{
      "minBirthDate" : minBirthDate.toString(),
      "maxBirthDate" : maxBirthDate.toString(),
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
    }));
    //TODO fix this to be part of the request.
    request.headers.addAll(_authHeader);
    request.headers.addAll(_uuid);



    //TODO add the body to the request.


    try {
      var streamedResponse = await request.send().timeout(const Duration(seconds: 5));
      var response = await http.Response.fromStream(streamedResponse);
      if(response.statusCode == 200){
        print("Success");
        //TODO decode response to get the uuid and token fields.
        //var pdfText= await json.decode(json.encode(response.databody);
        final Map parsed = json.decode(response.body);
        print(parsed['message']);
        return true;
      }else{
        print("Something's wrong");
        print(response);
        return false;
      }
    } on TimeoutException catch (e) {
      print('Timeout');
      print(e);
      return false;
    } on Error catch (e) {
      print('Error: $e');
      return false;
    }

  }
  */

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
    //TODO fix this to properly get the uuid.
    //request.fields['uuid']= await _uuid;

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

}

extension _StatusCode on int {
  bool get isOk => this >= 200 && this <= 300;
}
