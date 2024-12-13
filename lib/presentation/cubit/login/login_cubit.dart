import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_chat/domain/repositories/auth_repository.dart';
import 'package:web_socket_chat/domain/entities/app_user.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

@injectable

/// Cubit for the login screen, used to login to the web socket server
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const _Initial());

  final AuthRepository _authRepository;

  // Login to the web socket server, requires a username
  Future<void> login(String username) async {
    try {
      emit(const LoginState.loading());

      final token = await _authRepository.login(username);

      if (token != null) {
        final user = AppUser(
          token: token,
          username: username,
        );
        emit(LoginState.success(user));
      } else {
        emit(const LoginState.error('Failed to login'));
      }
    } catch (e) {
      emit(LoginState.error(e.toString()));
    }
  }
}
