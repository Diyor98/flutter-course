import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

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
    return Column(
      children: [
        TextField(
          controller: _email,
          decoration: const InputDecoration(hintText: 'Email'),
          autocorrect: false,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress,
        ),
        TextField(
          controller: _password,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Password'),
          enableSuggestions: false,
          autocorrect: false,
        ),
        TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final user = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: email, password: password);
                print(user);
              } on FirebaseAuthException catch (e) {
                print(e.code);
                if (e.code == 'user-not-found') {
                  print("User not found in Firebase");
                } else if (e.code == 'wrong-password') {
                  print('Wrong password');
                } else {
                  print('Unexpected firebase error');
                }
              } catch (e) {
                print('Unexpected error');
              }
            },
            child: const Text('Login'))
      ],
    );
  }
}
