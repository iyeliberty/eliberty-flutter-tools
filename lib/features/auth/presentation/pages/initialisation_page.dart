import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'home_page.dart';
import 'login_page.dart';

class InitialisationPage extends StatelessWidget {
  const InitialisationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current is AuthError,
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            Widget child;

            switch (state) {
              case AuthLoading _:
              case AuthInitial _:
                child = const Scaffold(
                  key: ValueKey('loading'),
                  body: Center(child: CircularProgressIndicator()),
                );
                break;

              case AuthAuthenticated userState:
                final user = userState.user;
                child = HomePage(key: const ValueKey('home'), user: user);
                break;

              case AuthUnauthenticated _:
                child = const LoginPage(key: ValueKey('login'));
                break;

              case AuthError _:
                child = const LoginPage(key: ValueKey('login'));
                break;

              default:
                child = const Scaffold(
                  key: ValueKey('unknown'),
                  body: Center(child: Text('Unknown state')),
                );
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: child,
            );
          },
        );
      },
    );
  }
}
