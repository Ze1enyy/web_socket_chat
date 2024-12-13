import 'package:flutter/material.dart';
import 'package:web_socket_chat/core/di/injector.dart';
import 'package:web_socket_chat/core/router/router.dart';

void main() {
  configureDependencies();
  runApp(const WebSocketChatApp());
}

class WebSocketChatApp extends StatelessWidget {
  const WebSocketChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WebSocket Chat',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: getIt<AppRouter>().config(),
    );
  }
}
