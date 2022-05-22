import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

/// Mocks an [http.Client]
class MockClient extends Mock implements http.Client {}
