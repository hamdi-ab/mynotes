import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new1/constants/routes.dart';
import 'package:new1/services/auth/auth_exceptions.dart';
import 'package:new1/services/auth/bloc/auth_bloc.dart';
import 'package:new1/services/auth/bloc/auth_event.dart';
import 'package:new1/services/auth/bloc/auth_state.dart';
import 'package:new1/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password',
            ),
          ),
          BlocListener<AuthBloc,AuthState>(
            listener: (context, state) async {
              if(state is AuthStateLoggedOut) {
                if(state.exception is UserNotFoundAuthExceptions){
                  await showErrorDialog(context, 'User not found');
                } else if (state.exception is WrongPasswordAuthExceptions){
                  await showErrorDialog(context, 'Wrong credentials');
                } else if (state.exception is GenericAuthExceptions){
                  await showErrorDialog(context, 'Authentication Error');
                }
              }
            },
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                context.read<AuthBloc>().add(AuthEventLogIn(email: email, password: password));
              },
              child: const Text('Login'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not Registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
