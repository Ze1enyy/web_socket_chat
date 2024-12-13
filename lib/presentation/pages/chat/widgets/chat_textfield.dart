part of '../chat_page.dart';

class _ChatTextField extends StatelessWidget {
  const _ChatTextField({
    required this.messageController,
    required this.sendMessage,
  });

  final TextEditingController messageController;

  final VoidCallback? sendMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'Type a message',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        BlocBuilder<SocketConnectionCubit, SocketConnectionState>(
          builder: (context, state) {
            return IconButton(
              icon: const Icon(Icons.send),
              onPressed: state.whenOrNull(
                connected: () => sendMessage,
              ),
            );
          },
        ),
      ],
    );
  }
}
