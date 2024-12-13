import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_chat/core/di/injector.config.dart';

final getIt = GetIt.instance;

/// Initialize DI
@injectableInit
GetIt configureDependencies() => getIt.init();
