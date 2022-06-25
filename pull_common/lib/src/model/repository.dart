import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pull_common/src/model/api_uris.dart';
import 'package:pull_common/src/model/entity/auth_request.dart';
import 'package:pull_common/src/model/entity/auth_response.dart';
import 'package:pull_common/src/model/exception/response_exception.dart';
import 'package:pull_common/src/model/provider/auth.dart';
import 'package:pull_common/src/model/provider/config.dart';
import 'package:pull_common/src/model/provider/match_stream.dart';
import 'package:riverpod/riverpod.dart';

import 'entity/match.dart';

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
    return {if (token != null) 'Authorization': 'Bearer $token'};
  }

  /// Get default headers for API requests
  Map<String, String> get _headers {
    return {..._authHeader, 'Content-Type': 'application/json'};
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
    final matchList = ((await _get(nextMatchesUri.replace(query: 'page_size=$pageSize')))['results'] as List)
        .map((e) => Match.fromJson(e));
    _read(activeRefreshProvider.notifier).state = false;
    _read(matchStreamControllerProvider).add(matchList);
  }
}

extension _StatusCode on int {
  bool get isOk => this >= 200 && this <= 300;
}
