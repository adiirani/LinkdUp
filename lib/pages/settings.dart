import 'package:flutter/material.dart';
import 'package:rizzlr/components/neumorphicboxthin.dart';
import 'package:provider/provider.dart';
import 'package:rizzlr/models/loginProvider.dart';
import 'package:rizzlr/pages/loginScreen.dart';
import 'package:rizzlr/theme/themeprov.dart';
import 'package:flutter/cupertino.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SETTINGS")),
      body: SingleChildScrollView( // Prevents overflow
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Dark Mode Toggle with Custom Gradient Switch
            NeuThinBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Dark Mode",
                      style: TextStyle(fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<Themeprov>(context, listen: false).toggleTheme();
                      },
                      child: Container(
                        width: 50,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: Provider.of<Themeprov>(context, listen: true).isDark
                                ? [Colors.purple.shade800, Colors.orange.shade700] // Dark mode: purple to orange
                                : [Colors.lime.shade300, Colors.lightBlue.shade100], // Light mode: lime green to light blue
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Provider.of<Themeprov>(context, listen: true).isDark
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
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

            const SizedBox(height: 20),

            // Logout Button
            NeuThinBox(
              child: ListTile(
                title: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.red)),
                trailing: const Icon(Icons.exit_to_app, color: Colors.red),
                onTap: () => _showConfirmationDialog(context, "Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Confirmation dialog for actions
  void _showConfirmationDialog(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm $action"),
          content: Text("Are you sure you want to $action? This cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (action == "Logout") {
                  // Call logout function here, e.g., log out user from your auth provider
                  _logout();
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Method to handle logout
  void _logout() {
    // Add your logout logic here, such as clearing user data or tokens
    Provider.of<LoginProvider>(context, listen: false).logout();
    
    // Show a Snackbar or another feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Successfully logged out")),
    );

    // Navigate to the login screen after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
