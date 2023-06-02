import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final Future<void> firebaseFuture;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    firebaseFuture = _initFirebase();
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
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
          future: firebaseFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
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
                            } else {
                              print('Unknown firebase exception'); 
                            }
                          } catch (e) {
                            print('Unexpected error');
                          }
                        },
                        child: const Text('Login'))
                  ],
                );
              default:
                return const Text('Loading...');
            }
          }),
    );
  }

  Future<void> _initFirebase() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
    } else {
      Firebase.app();
    }
  }
}