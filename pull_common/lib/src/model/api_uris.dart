
//AVD uses 10.0.2.2 as an alias for localhost.
const _baseUrl = 'http://10.0.2.2:3000'; // TODO put the actual URL here

final authUri = Uri.parse('$_baseUrl/auth');
final nextMatchesUri = Uri.parse('$_baseUrl/nextMatches');
final profileUri = Uri.parse('$_baseUrl/profile');
final profilePhotoLimitsUri = Uri.parse('$_baseUrl/profile/photoLimits');
final loginUri = Uri.parse('$_baseUrl/auth/login');
final filterUri = Uri.parse('$_baseUrl/filter');
