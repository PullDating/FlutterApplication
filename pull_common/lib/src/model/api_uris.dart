
//AVD uses 10.0.2.2 as an alias for localhost.
const baseAddress = '10.0.2.2:3000'; // TODO put the actual URL here
const baseUrl = 'http://$baseAddress';

final authUri = Uri.parse('$baseUrl/auth');
final nextMatchesUri = Uri.parse('$baseUrl/nextMatches');
final profileUri = Uri.parse('$baseUrl/profile');
final profilePhotoLimitsUri = Uri.parse('$baseUrl/profile/photoLimits');
final concurrentMatchLimitUri = Uri.parse('$baseUrl/global/concurrent-match-limit');
