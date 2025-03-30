import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:rizzlr/models/profileProvider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileProvider _profileProvider;
  final ImagePicker _picker = ImagePicker();

  // Controllers for name and bio input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Path to the profile image (local or remote)
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Load profile data when screen initializes
  }

  // Loads profile data and populates controllers
  Future<void> _loadProfile() async {
    _profileProvider = await ProfileProvider.loadProfile();
    _nameController.text = _profileProvider.name;
    _bioController.text = _profileProvider.bio;
    setState(() {
      _imagePath = _profileProvider.id; // Using `id` as placeholder image path
    });
  }

  // Opens the image picker and sets selected image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path); // Use local file path
      _profileProvider.saveProfile(); // Save profile (e.g., with new image path)
    }
  }

  // Builds the circular profile image widget
  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage, // Pick new image on tap
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: _imagePath.isEmpty
            ? const AssetImage('assets/default_profile.jpg') // Default image
            : FileImage(File(_imagePath)), // Local image file
        child: _imagePath.isEmpty
            ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
            : null,
      ),
    );
  }

  // Reusable function for building labeled text fields
  Widget _buildTextField(String label, TextEditingController controller, Function(String) onChanged, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  // Shows the list of linked social accounts with delete buttons
  Widget _buildSocialList() {
    return ExpansionTile(
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
    );
  }

  // Displays a dialog to add a new linked social account
  void _showAddSocialDialog() {
    final platformController = TextEditingController();
    final usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add Social Media'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField('Platform', platformController, (_) {}),
              const SizedBox(height: 10),
              _buildTextField('Username', usernameController, (_) {}),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (platformController.text.isNotEmpty && usernameController.text.isNotEmpty) {
                  setState(() {
                    _profileProvider.addLinkedSocial(
                      platformController.text,
                      usernameController.text,
                    );
                  });
                  Navigator.pop(context); // Close dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Always dispose controllers to avoid memory leaks
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileImage(), // Profile image section
              const SizedBox(height: 20),
              _buildTextField('Name', _nameController, (name) {
                _profileProvider.updateProfile(newName: name);
              }),
              const SizedBox(height: 20),
              _buildTextField('Bio', _bioController, (bio) {
                _profileProvider.updateProfile(newBio: bio);
              }, maxLines: 3),
              const SizedBox(height: 20),
              _buildSocialList(), // List of linked socials
              const SizedBox(height: 20),
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
}
