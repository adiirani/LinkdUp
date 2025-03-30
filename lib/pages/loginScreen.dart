import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizzlr/models/loginProvider.dart';
import 'package:rizzlr/home.dart';
import 'package:rizzlr/pages/signUp.dart';
import 'package:rizzlr/components/neumorphicboxthin.dart';
import 'package:rizzlr/components/gradientBox.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: NeuThinBox(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
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

                  /// **Clickable GradientBox**
                  GestureDetector(
                    onTap: () async {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      
                      final loginProvider =
                          Provider.of<LoginProvider>(context, listen: false);

                      await loginProvider.login(email, password);

                      if (loginProvider.isAuthenticated) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      } else {
                        setState(() {
                          _errorMessage = 'Invalid email or password';
                        });
                      }
                    },
                    child: GradientBox(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("Create Account"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
