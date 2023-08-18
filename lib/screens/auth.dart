import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/auth_controller.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthController get authController => Get.find();

  bool loading = false;

  Future<void> signIn(BuildContext context) async {
    setState(() => loading = true);

    await authController.signIn();

    setState(() => loading = false);

    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => loading ? null : signIn(context),
          child: loading
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(strokeWidth: 1, color: Colors.purple[900]),
                )
              : const Text('Sign In Anonymously'),
        ),
      ),
    );
  }
}
