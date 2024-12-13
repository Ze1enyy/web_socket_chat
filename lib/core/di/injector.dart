import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:web_socket_chat/core/di/injector.config.dart';

final getIt = GetIt.instance;

@module
abstract class RegisterModule {
  @singleton
  http.Client get httpClient => http.Client();
}

/// Initialize DI
@injectableInit
void configureDependencies() => getIt.init();
