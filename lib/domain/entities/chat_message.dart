class ChatMessage {
  final String username;
  final String message;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.username,
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, {String? currentUsername}) {
    return ChatMessage(
      username: json['username'] ?? '',
      message: json['message'] ?? '',
      isMe: currentUsername != null && json['username'] == currentUsername,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
