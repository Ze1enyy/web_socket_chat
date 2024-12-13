import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_chat/core/router/router.gr.dart';

/// App router
@injectable
@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: ChatRoute.page),
      ];
}
