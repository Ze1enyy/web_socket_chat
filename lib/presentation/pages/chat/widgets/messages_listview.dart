part of '../chat_page.dart';

class _MessagesListView extends StatelessWidget {
  const _MessagesListView();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) {
          return state.when(
            error: (error) => const Center(child: Text('Error')),
            loading: () => const Center(child: CircularProgressIndicator()),
            initial: () => const SizedBox.shrink(),
            success: (messages) {
              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  return _MessageBubble(message: message);
                },
              );
            },
          );
        },
      ),
    );
  }
}
