import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_chat/core/di/injector.dart';
import 'package:web_socket_chat/core/router/router.gr.dart';
import 'package:web_socket_chat/domain/entities/app_user.dart';
import 'package:web_socket_chat/domain/entities/chat_message.dart';
import 'package:web_socket_chat/presentation/cubit/messages/messages_cubit.dart';
import 'package:web_socket_chat/presentation/cubit/socket_connection/socket_connection_cubit.dart';

part 'widgets/connection_dot.dart';
part 'widgets/chat_textfield.dart';
part 'widgets/messages_listview.dart';
part 'widgets/message_bubble.dart';

@RoutePage()
class ChatPage extends StatefulWidget implements AutoRouteWrapper {
  const ChatPage({
    required this.user,
    super.key,
  });

  final AppUser user;

  @override
  State<ChatPage> createState() => _ChatPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SocketConnectionCubit>()),
        BlocProvider(create: (context) => getIt<MessagesCubit>()),
      ],
      child: this,
    );
  }
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SocketConnectionCubit>().init(widget.user);

    context.read<MessagesCubit>().getMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          const _ConnectionDot(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.router.pushAndPopUntil(
              const LoginRoute(),
              predicate: (route) => false,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const _MessagesListView(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: _ChatTextField(
                messageController: _messageController,
                sendMessage: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to send a message to the server
  void _sendMessage() {
    if (_messageController.text.isEmpty) return;
    context.read<MessagesCubit>().sendMessage(_messageController.text);
    _messageController.clear();
  }

  @override
  void dispose() {
    // Dispose of the message controller
    _messageController.dispose();

    super.dispose();
  }
}
