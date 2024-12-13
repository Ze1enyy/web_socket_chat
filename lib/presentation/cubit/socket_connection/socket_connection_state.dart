part of 'socket_connection_cubit.dart';

@freezed
class SocketConnectionState with _$SocketConnectionState {
  const factory SocketConnectionState.initial() = _Initial;
  const factory SocketConnectionState.connected() = _Connected;
  const factory SocketConnectionState.disconnected() = _Disconnected;
  const factory SocketConnectionState.loading() = _Loading;
}
