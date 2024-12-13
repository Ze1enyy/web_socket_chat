import 'package:web_socket_chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  /// Stream of messages from the server, used to listen to messages
  Stream<List<ChatMessage>> get messagesStream;

  /// Stream of connection status, used to listen to connection status
  Stream<bool> get connectionStatusStream;

  /// Send a message to the server, used to send messages to the server
  void sendMessage(String message);

  /// Connect to the web socket server, used to connect to the server
  void connect(String token, String username);

  /// Disconnect from the web socket server, used to disconnect from the server
  void disconnect();
}
