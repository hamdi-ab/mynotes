import 'package:flutter/material.dart';
import 'package:new1/constants/routes.dart';
import 'package:new1/services/auth/auth_service.dart';
import 'package:new1/view/login_view.dart';
import 'package:new1/view/notes/notes_view.dart';
import 'package:new1/view/register_view.dart';
import 'package:new1/view/verify_email_view.dart';
import 'package:new1/view/notes/new_note_view.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        noteRoute: (context) => const NoteView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView()
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}