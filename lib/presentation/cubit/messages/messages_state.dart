part of 'messages_cubit.dart';

@freezed
class MessagesState with _$MessagesState {
  const factory MessagesState.initial() = _Initial;
  const factory MessagesState.loading() = _Loading;
  const factory MessagesState.error(String message) = _Error;
  const factory MessagesState.success(List<ChatMessage> messages) = _Success;
}
