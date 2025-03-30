import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:rizzlr/components/gradientBox.dart';
import 'package:rizzlr/models/profileProvider.dart';
import 'package:rizzlr/models/loginProvider.dart';
import 'package:rizzlr/pages/loginScreen.dart';
import 'package:reorderables/reorderables.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  late ProfileProvider _profileProvider;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _imagePath = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    _profileProvider = await ProfileProvider.loadProfile();
    _nameController.text = _profileProvider.name;
    _bioController.text = _profileProvider.bio;
    setState(() {
      _imagePath = _profileProvider.profileImage;
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
        _profileProvider.updateProfile(newProfileImage: _imagePath);
      });
    }
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey.shade300,
        backgroundImage: _imagePath.isEmpty
            ? const AssetImage('assets/default_profile.jpg')
            : FileImage(File(_imagePath)) as ImageProvider,
        child: _imagePath.isEmpty
            ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
            : null,
      ),
    );
  }

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

  Widget _buildPhotoGallery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photo Gallery', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ReorderableWrap(
          spacing: 12,
          runSpacing: 12,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              _profileProvider.reorderPhotos(oldIndex, newIndex);
            });
          },
          children: List.generate(_profileProvider.uploadedPhotos.length, (index) {
            final path = _profileProvider.uploadedPhotos[index];
            final caption = _profileProvider.photoCaptions[path] ?? '';

            return GestureDetector(
              key: ValueKey(path),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: [
                        Image.file(File(path), fit: BoxFit.contain),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Text(
                            caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(path),
                      height: 140, // Bigger gallery image
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _profileProvider.removePhoto(index);
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: GestureDetector(
                      onTap: () async {
                        final captionController = TextEditingController(text: caption);
                        await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Edit Caption"),
                            content: TextField(
                              controller: captionController,
                              decoration: const InputDecoration(hintText: "Enter caption"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _profileProvider.updateCaption(path, captionController.text);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            final picked = await _picker.pickImage(source: ImageSource.gallery);
            if (picked != null) {
              setState(() {
                _profileProvider.addPhoto(picked.path);
              });
            }
          },
          child: const GradientBox(
          child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Text(
                  "Add Photo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

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

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileImage(),
              const SizedBox(height: 20),
              _buildTextField('Name', _nameController, (name) {
                _profileProvider.updateProfile(newName: name);
              }),
              const SizedBox(height: 20),
              _buildTextField('Bio', _bioController, (bio) {
                _profileProvider.updateProfile(newBio: bio);
              }, maxLines: 3),
              const SizedBox(height: 20),
              _buildPhotoGallery(),
              _buildSocialList(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _showAddSocialDialog,
                child: const GradientBox(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        "Add Linked Social",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
