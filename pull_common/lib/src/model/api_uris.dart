
//AVD uses 10.0.2.2 as an alias for localhost.
import 'package:flutter/foundation.dart';


String _getBaseUrl(){
  if(defaultTargetPlatform == TargetPlatform.android){
    print("Using DEV android baseuri");
    return 'http://10.0.2.2:3000';
  }else if (defaultTargetPlatform == TargetPlatform.iOS){
    print("Using DEV ios baseuri");
    return 'http://localhost:3000';
  } else {
    throw Exception("There was an error retrieving the correct baseurl");
  }
}

final authUri = Uri.parse('${_getBaseUrl()}/auth');
final nextMatchesUri = Uri.parse('${_getBaseUrl()}/nextMatches');
final profileUri = Uri.parse('${_getBaseUrl()}/profile');
final firstPhotoUri = Uri.parse('${_getBaseUrl()}/profile/primaryphoto');
final profilePhotoLimitsUri = Uri.parse('${_getBaseUrl()}/profile/photoLimits');
final loginUri = Uri.parse('${_getBaseUrl()}/auth/login');
final filterUri = Uri.parse('${_getBaseUrl()}/filter');
final peopleUri = Uri.parse('${_getBaseUrl()}/people');
