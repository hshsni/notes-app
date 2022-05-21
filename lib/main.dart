import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/Views/login_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: "Notes",
      theme:
          ThemeData(brightness: Brightness.light, primarySwatch: Colors.orange),
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              var user = FirebaseAuth.instance.currentUser;

              if (user?.emailVerified ?? false) {
                return const Center(child: Text("Firebase initializing done"));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailVerifyView(),
                  ),
                );
                return const Center(
                    child: Text("Firebase initializing not done"));
              }
            default:
              return const Center(child: Text("Loading..."));
          }
        },
      ),
    );
  }
}

class EmailVerifyView extends StatefulWidget {
  const EmailVerifyView({Key? key}) : super(key: key);

  @override
  State<EmailVerifyView> createState() => _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify email"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Please verify your email"),
            const SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Verify"),
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
