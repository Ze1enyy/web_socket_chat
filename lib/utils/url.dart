abstract class Url {
  /// Base URL for the web socket server
  static const String baseUrl = 'http://10.0.2.2:3001';

  /// Login URL for the web socket server
  static const String loginUrl = '$baseUrl/login';

  /// Web socket URL for the web socket server
  static const String wsUrl = 'ws://10.0.2.2:3001';

  /// Chat URL for the web socket server
  static const String chatUrl = '$wsUrl/chat';
}
