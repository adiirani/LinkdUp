import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizzlr/models/loginProvider.dart';
import 'package:rizzlr/components/gradientBox.dart';
import '../theme/themeprov.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<Themeprov>(context, listen: false).isDark;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),

              /// Clickable GradientBox
              GestureDetector(
                onTap: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();

                  bool success = await Provider.of<LoginProvider>(context, listen: false)
                      .createAccount(email, password);

                  if (success) {
                    Navigator.pop(context); // Go back to Login Screen
                  } else {
                    setState(() {
                      _errorMessage = 'Email already in use';
                    });
                  }
                },
                child: GradientBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
