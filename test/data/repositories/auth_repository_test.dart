import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:web_socket_chat/data/repositories/auth_repository_impl.dart';
import 'package:web_socket_chat/domain/repositories/auth_repository.dart';
import 'package:web_socket_chat/utils/exceptions.dart';

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepository authRepository;
    late MockClient mockClient;

    const testToken = 'test_token';

    setUp(() {
      mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/login')) {
          final body = jsonDecode(request.body);
          if (body['username'] == 'testUser') {
            return http.Response(
              jsonEncode({
                'success': true,
                'token': testToken,
              }),
              200,
            );
          }
        }
        return http.Response(
          jsonEncode({
            'success': false,
            'message': 'Invalid username',
          }),
          400,
        );
      });

      authRepository = AuthRepositoryImpl(client: mockClient);
    });

    test('should login successfully with valid username', () async {
      final token = await authRepository.login('testUser');
      expect(token, testToken);
    });

    test('should throw LoginException when login fails', () async {
      expect(
        () => authRepository.login('invalidUser'),
        throwsA(isA<LoginException>()),
      );
    });
    test('should throw LoginException when server returns invalid response', () async {
      mockClient = MockClient((request) async {
        return http.Response('invalid json', 200);
      });

      authRepository = AuthRepositoryImpl(client: mockClient);
      expect(
        () => authRepository.login('testUser'),
        throwsA(isA<LoginException>()),
      );
    });

    test('should throw LoginException when network error occurs', () async {
      mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      authRepository = AuthRepositoryImpl(client: mockClient);
      expect(
        () => authRepository.login('testUser'),
        throwsA(isA<LoginException>()),
      );
    });
  });
}
