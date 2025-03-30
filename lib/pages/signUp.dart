import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rizzlr/components/neumorphicboxthin.dart';
import 'package:rizzlr/models/loginProvider.dart';
import 'package:rizzlr/models/profileProvider.dart';
import 'package:rizzlr/components/gradientBox.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _errorMessage = '';
  String _profileImage = ''; // To hold the profile image path or URL
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: NeuThinBox(
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
                const SizedBox(height: 10),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(height: 20),
                
                // Profile image selection using NeuThinBox
                NeuThinBox(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          _profileImage.isEmpty
                              ? "Upload Profile Image"
                              : "Change Profile Image",
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
                const SizedBox(height: 20),
                
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),

                /// NeuThinBox button for Sign Up
                GradientBox(
                  child: GestureDetector(
                    onTap: () async {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      String username = _usernameController.text.trim();
                      String bio = _bioController.text.trim();

                      bool success = await Provider.of<LoginProvider>(context, listen: false)
                          .createAccount(email, password);

                      if (success) {
                        // Create a new profile
                        var profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                        profileProvider.id = const Uuid().v4();
                        profileProvider.name = username.isEmpty ? email.split('@')[0] : username; // Use username or email prefix
                        profileProvider.bio = bio.isEmpty ? "Hello! I'm new here." : bio;
                        profileProvider.linkedSocials = {};
                        profileProvider.friends = [];
                        profileProvider.profileImage = _profileImage; // Save the profile image path
                        profileProvider.saveProfile();

                        Navigator.pop(context); // Go back to Login Screen
                      } else {
                        setState(() {
                          _errorMessage = 'Email already in use';
                        });
                      }
                    },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            "Sign Up"
                          ),
                        ),
                      ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // Back to login button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to Login Screen
                  },
                  child: const Text(
                    "Back to Login"
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
