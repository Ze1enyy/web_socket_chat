// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i5;
import 'package:web_socket_chat/domain/entities/app_user.dart' as _i4;
import 'package:web_socket_chat/presentation/pages/chat/chat_page.dart' as _i1;
import 'package:web_socket_chat/presentation/pages/login/login_page.dart'
    as _i2;

/// generated route for
/// [_i1.ChatPage]
class ChatRoute extends _i3.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    required _i4.AppUser user,
    _i5.Key? key,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            user: user,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return _i3.WrappedRoute(
          child: _i1.ChatPage(
        user: args.user,
        key: args.key,
      ));
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    required this.user,
    this.key,
  });

  final _i4.AppUser user;

  final _i5.Key? key;

  @override
  String toString() {
    return 'ChatRouteArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [_i2.LoginPage]
class LoginRoute extends _i3.PageRouteInfo<void> {
  const LoginRoute({List<_i3.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return _i3.WrappedRoute(child: const _i2.LoginPage());
    },
  );
}
