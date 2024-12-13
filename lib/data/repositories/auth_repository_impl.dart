import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:web_socket_chat/domain/repositories/auth_repository.dart';
import 'package:web_socket_chat/utils/exceptions.dart';
import 'package:web_socket_chat/utils/url.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;

  AuthRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<String?> login(String username) async {
    try {
      final response = await client.post(
        Uri.parse(Url.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['token'];
        }
      }

      if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw LoginException(data['message']);
      }

      throw LoginException('Failed to login');
    } on SocketException catch (_) {
      throw LoginException('No socket connection');
    } on FormatException {
      throw LoginException('Invalid response format');
    } catch (e) {
      throw LoginException(e.toString());
    }
  }
}
