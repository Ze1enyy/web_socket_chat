part of '../chat_page.dart';

class _ConnectionDot extends StatelessWidget {
  const _ConnectionDot();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocketConnectionCubit, SocketConnectionState>(
      listener: (context, state) {
        state.whenOrNull(
          disconnected: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Web socket disconnected'),
              ),
            );
            context.router.pushAndPopUntil(
              const LoginRoute(),
              predicate: (route) => false,
            );
          },
        );
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16.0),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: state.when(
              initial: () => Colors.grey,
              connected: () => Colors.green,
              disconnected: () => Colors.red,
              loading: () => Colors.yellow,
            ),
          ),
        );
      },
    );
  }
}
