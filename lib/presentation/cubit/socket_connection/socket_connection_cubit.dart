import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_chat/domain/entities/app_user.dart';
import 'package:web_socket_chat/domain/repositories/chat_repository.dart';

part 'socket_connection_state.dart';
part 'socket_connection_cubit.freezed.dart';

@injectable

/// Cubit for the socket connection, used to connect to the web socket server
class SocketConnectionCubit extends Cubit<SocketConnectionState> {
  SocketConnectionCubit(this._chatRepository) : super(const _Initial());

  final ChatRepository _chatRepository;

  StreamSubscription? subscription;

  /// Connect to the web socket server
  Future<void> init(AppUser user) async {
    try {
      emit(const _Loading());
      _chatRepository.connect(user.token, user.username);
      if (subscription != null) await _clearSubscription();

      subscription = _chatRepository.connectionStatusStream.listen(
        (isConnected) => emit(
          isConnected ? const _Connected() : const _Disconnected(),
        ),
      );
    } on Exception catch (_) {
      emit(const _Disconnected());
    }
  }

  Future<void> _clearSubscription() async {
    await subscription?.cancel();
    subscription = null;
  }

  @override
  Future<void> close() async {
    // Disconnect from the web socket server
    _chatRepository.disconnect();

    // Clear the subscription
    await _clearSubscription();

    return super.close();
  }
}
