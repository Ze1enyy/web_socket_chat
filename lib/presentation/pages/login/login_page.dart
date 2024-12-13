import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_chat/core/di/injector.dart';
import 'package:web_socket_chat/core/router/router.gr.dart';
import 'package:web_socket_chat/presentation/cubit/login/login_cubit.dart';

part 'widgets/continue_button.dart';
part 'widgets/user_name_textfield.dart';

@RoutePage()
class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: this,
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  bool _isUsernameEmpty = true;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_usernameListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        bloc: context.read<LoginCubit>(),
        listener: _handleLoginState,
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            orElse: () => SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter your username to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _UserNameTextField(usernameController: _usernameController),
                    const SizedBox(height: 24),
                    _ContinueButton(
                      isUsernameEmpty: _isUsernameEmpty,
                      onPressed: () => context
                          .read<LoginCubit>()
                          .login(_usernameController.text),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to handle the login state
  void _handleLoginState(BuildContext context, LoginState state) {
    state.whenOrNull(
      success: (user) {
        context.router.replace(ChatRoute(user: user));
      },
      error: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  }

  // Function to listen to the username controller
  void _usernameListener() {
    setState(() {
      _isUsernameEmpty = _usernameController.text.trim().isEmpty;
    });
  }

  @override
  void dispose() {
    // Remove the listener from the username controller
    _usernameController.removeListener(_usernameListener);
    
    // Dispose of the username controller
    _usernameController.dispose();

    super.dispose();
  }
}
