import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pull_common/pull_common.dart';
import 'package:pull_common/src/model/exception/response_exception.dart';
import 'package:test/test.dart';

import 'mocks.dart';

/// This file contains pure-Dart tests that don't depend on Flutter.
void main() {
  group('Authentication', () {
    test('Authenticating sets the auth token', () async {
      final client = MockClient();
      final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(client)]);

      expect(container.read(networkAuthTokenProvider), equals(null));
      final repository = container.read(repositoryProvider);

      final authRequest =
          AuthRequest.emailPassword('test@example.com', 'p@ssword123!');
      final authRequestJson = authRequest.toJson();

      final authResult = Future.value(Response('sample_token', 200));

      when(() => client.post(authUri, headers: {}, body: authRequestJson))
          .thenAnswer((_) => authResult);
      final token = await repository.authenticate(authRequest);
      verify(() => client.post(authUri, headers: {}, body: authRequestJson))
          .called(1);

      expect(token, equals('sample_token'));
      expect(container.read(networkAuthTokenProvider), equals('sample_token'));
    });

    test('Server error causes authentication to throw', () async {
      final client = MockClient();
      final container = ProviderContainer(
          overrides: [httpClientProvider.overrideWithValue(client)]);

      final repository = container.read(repositoryProvider);

      final authRequest =
          AuthRequest.emailPassword('test@example.com', 'p@ssword123!');
      final authRequestJson = authRequest.toJson();

      final authResult = Future.value(Response('Internal Server Error', 500));

      when(() => client.post(authUri, headers: {}, body: authRequestJson))
          .thenAnswer((_) => authResult);
      await expectLater(repository.authenticate(authRequest),
          throwsA(isA<ResponseException>()));
      verify(() => client.post(authUri, headers: {}, body: authRequestJson))
          .called(1);

      expect(container.read(networkAuthTokenProvider), equals(null));
    });
  });
}
