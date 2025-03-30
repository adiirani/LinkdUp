import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'profileProvider.dart';

part 'friendProvider.g.dart'; // Required for Hive TypeAdapter

@HiveType(typeId: 1)
class FriendProvider extends ChangeNotifier {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String bio;

  @HiveField(3)
  Map<String, String> linkedSocials; // e.g., {"twitter": "@user", "github": "user123"}

  FriendProvider({
    required this.id,
    required this.name,
    required this.bio,
    required this.linkedSocials,
  });

  /// Converts a ProfileProvider to a FriendProvider
  factory FriendProvider.fromProfile(ProfileProvider profile) {
    return FriendProvider(
      id: profile.id,
      name: profile.name,
      bio: profile.bio,
      linkedSocials: Map<String, String>.from(profile.linkedSocials),
    );
  }

  /// Saves friend profile to Hive
  Future<void> saveFriend() async {
    var box = await Hive.openBox<FriendProvider>('friendBox');
    box.put(id, this);
    notifyListeners();
  }

  /// Updates friend details
  void updateFriend({String? newName, String? newBio}) {
    if (newName != null) name = newName;
    if (newBio != null) bio = newBio;
    saveFriend();
  }

  /// Adds a linked social media account
  void addLinkedSocial(String platform, String username) {
    linkedSocials[platform] = username;
    saveFriend();
  }

  /// Removes a linked social media account
  void removeLinkedSocial(String platform) {
    linkedSocials.remove(platform);
    saveFriend();
  }
}