import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_chat/domain/entities/chat_message.dart';
import 'package:web_socket_chat/domain/repositories/chat_repository.dart';
import 'package:web_socket_chat/utils/url.dart';

@Singleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final _messagesList = <ChatMessage>[];

  IOWebSocketChannel? _channel;

  StreamController<bool>? _connectionStatusController;
  StreamController<List<ChatMessage>>? _messagesController;

  String? _username;

  @override
  Stream<List<ChatMessage>> get messagesStream =>
      _messagesController?.stream ?? Stream.value([]);

  @override
  Stream<bool> get connectionStatusStream =>
      _connectionStatusController?.stream ?? Stream.value(_channel != null);

  @override
  void sendMessage(String message) {
    if (message.isEmpty || _channel == null) return;

    final data = {
      'type': 'message',
      'message': message,
    };

    _channel?.sink.add(jsonEncode(data));
  }

  @override
  void connect(String token, String username) {
    // Disconnect from the previous connection if it exists
    disconnect();

    _connectionStatusController = StreamController<bool>.broadcast();
    _messagesController = StreamController<List<ChatMessage>>.broadcast();

    _username = username;
    final wsUrl = Uri.parse(Url.chatUrl);
    _channel = IOWebSocketChannel.connect(wsUrl);

    final authData = {
      'type': 'auth',
      'token': token,
    };

    _channel?.sink.add(jsonEncode(authData));

    _listenToMessages();
  }

  // Listen to messages from the server and handle them
  void _listenToMessages() {
    _channel?.stream.listen(
      (message) => _handleWebSocketMessage(jsonDecode(message)),
      onError: (error) => _connectionStatusController?.add(false),
      onDone: () => _connectionStatusController?.add(false),
    );
  }

  // Handle messages from the server
  void _handleWebSocketMessage(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'auth':
        _handleAuthMessage(data);
        break;
      case 'history':
        _handleHistoryMessage(data);
        break;
      case 'message':
        _handleChatMessage(data);
        break;
    }
  }

  // Handle authentication messages from the server
  void _handleAuthMessage(Map<String, dynamic> data) {
    if (data['success'] == true) {
      _connectionStatusController?.add(true);
    }
  }

  // Handle history messages from the server
  void _handleHistoryMessage(Map<String, dynamic> data) {
    _messagesList.clear();
    for (var msg in data['messages']) {
      _messagesList.add(ChatMessage.fromJson(msg, currentUsername: _username));
    }
    _messagesController?.add(_messagesList);
  }

  // Handle chat messages from the server
  void _handleChatMessage(Map<String, dynamic> data) {
    final chatMessage = ChatMessage.fromJson(data, currentUsername: _username);
    _messagesList.add(chatMessage);
    _messagesController?.add(_messagesList);
  }

  @override
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _connectionStatusController?.close();
    _connectionStatusController = null;
    _messagesController?.close();
    _messagesController = null;
    _messagesList.clear();
  }
}
