import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => RegiterViewState();
}

class RegiterViewState extends State<RegisterView> {
  late TextEditingController _email;
  late TextEditingController _password;

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
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snaphost) {
          switch (snaphost.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(hintText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                  TextField(
                    controller: _password,
                    decoration: const InputDecoration(hintText: 'Password'),
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final user = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print(user);
                        } on FirebaseAuthException catch (e) {
                          print(e.code);
                          if (e.code == 'weak-password') {
                            print('Weak password');
                          } else if (e.code == 'email-already-in-use') {
                            print('Email already in use');
                          } else if (e.code == 'invalid-email') {
                            print('Invalid email');
                          } else {
                            print('Unexpected error');
                          }
                        }
                      },
                      child: const Text('Register'))
                ],
              );
            default:
              return const Text('Loading');
          }
        },
      ),
    );
  }

  Future<void> _initializeFirebase() async {
    if (Firebase.apps.isEmpty) {
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } else {
      Firebase.app();
    }
  }
}
