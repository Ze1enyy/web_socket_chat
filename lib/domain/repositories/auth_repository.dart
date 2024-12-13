abstract class AuthRepository {
  /// Login to the web socket server, returns the token if successful
  Future<String?> login(String username);
} 