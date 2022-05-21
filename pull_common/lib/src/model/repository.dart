import 'package:http/http.dart' as http;
import 'package:pull_common/src/model/api_uris.dart';
import 'package:pull_common/src/model/entity/auth_request.dart';
import 'package:pull_common/src/model/exception/response_exception.dart';
import 'package:pull_common/src/model/provider/auth.dart';
import 'package:riverpod/riverpod.dart';

final httpClientProvider = Provider<http.Client>((_) => http.Client());

/// Repository for the Pull API
class PullRepository {
  PullRepository(this._read);

  // A [Reader] allows the API to read other providers, like to get API tokens
  final Reader _read;

  /// Derive an auth header from [authTokenProvider]
  Map<String, String> get _authHeader {
    final token = _read(authTokenProvider);
    return {if (token != null) 'Authorization': 'Bearer $token'};
  }

  /// Get the HTTP client
  http.Client get _client => _read(httpClientProvider);

  /// Perform an (authenticated, if possible) GET request
  Future<String> _get(Uri uri) async {
    final response = await _client.get(uri, headers: await _authHeader);

    if (!response.statusCode.isOk) {
      throw ResponseException(response.statusCode, message: response.body);
    }

    return response.body;
  }

  /// Perform an (authenticated, if possible) POST request with optional body
  Future<String> _post(Uri uri, {Object? body}) async {
    final response = await _client.post(uri, headers: await _authHeader, body: body);

    if (!response.statusCode.isOk) {
      throw ResponseException(response.statusCode, message: response.body);
    }

    return response.body;
  }

  /// Get an auth token from the Pull API and update the [networkAuthTokenProvider]'s state
  Future<String> authenticate(AuthRequest authRequest) async {
    final token = await _post(authUri, body: authRequest.toJson());
    return _read(networkAuthTokenProvider.notifier).state = token;
  }
}

extension _StatusCode on int {
  bool get isOk => this >= 200 && this <= 300;
}
