import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'profileProvider.g.dart'; // Required for Hive TypeAdapter

@HiveType(typeId: 0)
class ProfileProvider extends ChangeNotifier {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String bio;

  @HiveField(3)
  String profileImage;

  @HiveField(4)
  Map<String, String> linkedSocials; // e.g., {"twitter": "@user", "github": "user123"}

  @HiveField(5)
  List<String> friends; // List of friend IDs

  ProfileProvider({
    required this.id,
    required this.profileImage,
    required this.name,
    required this.bio,
    required this.linkedSocials,
    required this.friends,
  });

  /// Initializes the profile from Hive or creates a default one
  static Future<ProfileProvider> loadProfile() async {
    var box = await Hive.openBox<ProfileProvider>('profileBox');
    if (box.isNotEmpty) {
      return box.get('profile')!;
    } else {
      // Default profile if none exists
      var newProfile = ProfileProvider(
        id: const Uuid().v4(), // Generate a unique ID
        name: 'New User',
        bio: 'This is my bio',
        linkedSocials: {},
        friends: [],
        profileImage: '', // Set a default value for profileImage
      );
      await newProfile.saveProfile(); // Save the newly created profile to Hive
      return newProfile;
    }
  }

  /// Saves profile to Hive
  Future<void> saveProfile() async {
    var box = await Hive.openBox<ProfileProvider>('profileBox');
    await box.put('profile', this); // Save the profile under the 'profile' key
    notifyListeners();
  }

  /// Updates profile details
  void updateProfile({String? newName, String? newBio, String? newProfileImage}) {
    if (newName != null) name = newName;
    if (newBio != null) bio = newBio;
    if (newProfileImage != null) profileImage = newProfileImage;
    saveProfile();
  }

  /// Adds a linked social media account
  void addLinkedSocial(String platform, String username) {
    linkedSocials[platform] = username;
    saveProfile();
  }

  /// Removes a linked social media account
  void removeLinkedSocial(String platform) {
    linkedSocials.remove(platform);
    saveProfile();
  }

  /// Adds a friend by ID
  void addFriend(String friendId) {
    if (!friends.contains(friendId)) {
      friends.add(friendId);
      saveProfile();
    }
  }

  /// Removes a friend by ID
  void removeFriend(String friendId) {
    friends.remove(friendId);
    saveProfile();
  }
}
