
import 'package:flutter/material.dart';
import 'package:new1/constants/routes.dart';
import 'package:new1/services/auth/auth_exceptions.dart';
import 'package:new1/services/auth/auth_service.dart';
import 'package:new1/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthExceptions{
                await showErrorDialog(context, 'weak Password');
              } on EmailAlreadyInUseAuthExceptions{
                await showErrorDialog(
                    context, 'This email is already in use');
              } on InvalidEmailAuthExceptions{
                await showErrorDialog(context, 'You put an Invalid Email');
              } on GenericAuthExceptions{
                await showErrorDialog(context, 'Failed to register');
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (context) => false);
            },
            child: const Text('Already have an account? login here!'),
          ),
        ],
      ),
    );
  }
}
