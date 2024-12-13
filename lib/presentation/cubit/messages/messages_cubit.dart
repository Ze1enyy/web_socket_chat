import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_chat/domain/entities/chat_message.dart';
import 'package:web_socket_chat/domain/repositories/chat_repository.dart';

part 'messages_state.dart';
part 'messages_cubit.freezed.dart';

@injectable

/// Cubit for the messages screen, used to get messages from the server
class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit(this._chatRepository) : super(const _Initial());

  final ChatRepository _chatRepository;

  StreamSubscription? subscription;

  /// Get messages from the server
  Future<void> getMessages() async {
    try {
      if (subscription != null) await _clearSubscription();

      subscription = _chatRepository.messagesStream.listen((e) {
        emit(const _Loading());
        emit(_Success(e));
      });
    } on Exception catch (_) {
      emit(const _Error('Failed to get messages'));
    }
  }

  /// Send a message to the server
  Future<void> sendMessage(String message) async {
    try {
      _chatRepository.sendMessage(message);
    } on Exception catch (_) {
      emit(const _Error('Failed to send message'));
    }
  }

  Future<void> _clearSubscription() async {
    await subscription?.cancel();
    subscription = null;
  }

  @override
  Future<void> close() async {
    // Clear the subscription when the cubit is closed
    await _clearSubscription();
    return super.close();
  }
}
