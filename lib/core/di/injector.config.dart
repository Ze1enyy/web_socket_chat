// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:web_socket_chat/core/di/injector.dart' as _i794;
import 'package:web_socket_chat/core/router/router.dart' as _i730;
import 'package:web_socket_chat/data/repositories/auth_repository_impl.dart'
    as _i389;
import 'package:web_socket_chat/data/repositories/chat_repository_impl.dart'
    as _i872;
import 'package:web_socket_chat/domain/repositories/auth_repository.dart'
    as _i401;
import 'package:web_socket_chat/domain/repositories/chat_repository.dart'
    as _i190;
import 'package:web_socket_chat/presentation/cubit/login/login_cubit.dart'
    as _i306;
import 'package:web_socket_chat/presentation/cubit/messages/messages_cubit.dart'
    as _i424;
import 'package:web_socket_chat/presentation/cubit/socket_connection/socket_connection_cubit.dart'
    as _i432;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i730.AppRouter>(() => _i730.AppRouter());
    gh.singleton<_i519.Client>(() => registerModule.httpClient);
    gh.singleton<_i190.ChatRepository>(() => _i872.ChatRepositoryImpl());
    gh.factory<_i432.SocketConnectionCubit>(
        () => _i432.SocketConnectionCubit(gh<_i190.ChatRepository>()));
    gh.factory<_i424.MessagesCubit>(
        () => _i424.MessagesCubit(gh<_i190.ChatRepository>()));
    gh.factory<_i401.AuthRepository>(
        () => _i389.AuthRepositoryImpl(client: gh<_i519.Client>()));
    gh.factory<_i306.LoginCubit>(
        () => _i306.LoginCubit(gh<_i401.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i794.RegisterModule {}
