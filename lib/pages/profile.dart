import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:rizzlr/models/profileProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';  // Add this import for File

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileProvider _profileProvider;
  final ImagePicker _picker = ImagePicker();
  String _imageUrl = ''; // URL or path of the profile image

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    _profileProvider = await ProfileProvider.loadProfile();
    setState(() {
      _imageUrl = _profileProvider.id; // Default to ID, but can be updated with a real image URL
    });
  }

  // Function to pick a new profile image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Here you would upload the image and get the URL
      setState(() {
        _imageUrl = pickedFile.path; // Local path for now
      });
      // Save to ProfileProvider (if needed, like an uploaded URL)
      _profileProvider.saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture Section
              GestureDetector(
                onTap: _pickImage, // Tap to pick a new image
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _imageUrl.isEmpty
                      ? const AssetImage('assets/default_profile.jpg') // Default image
                      : FileImage(File(_imageUrl)) as ImageProvider,
                  child: _imageUrl.isEmpty
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              // Profile Name Field
              TextField(
                controller: TextEditingController(text: _profileProvider.name),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newName) {
                  _profileProvider.updateProfile(newName: newName);
                },
              ),
              const SizedBox(height: 20),
              // Bio Field
              TextField(
                controller: TextEditingController(text: _profileProvider.bio),
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                onChanged: (newBio) {
                  _profileProvider.updateProfile(newBio: newBio);
                },
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Linked Socials
              ExpansionTile(
                title: const Text('Linked Socials'),
                children: _profileProvider.linkedSocials.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _profileProvider.removeLinkedSocial(entry.key);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Add Linked Socials Button
              ElevatedButton(
                onPressed: _showAddSocialDialog,
                child: const Text('Add Linked Social'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog to add a new social media account
  void _showAddSocialDialog() {
    final TextEditingController platformController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Social Media'),
          content: Column(
            children: [
              TextField(
                controller: platformController,
                decoration: const InputDecoration(labelText: 'Platform'),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (platformController.text.isNotEmpty &&
                    usernameController.text.isNotEmpty) {
                  setState(() {
                    _profileProvider.addLinkedSocial(
                      platformController.text,
                      usernameController.text,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
