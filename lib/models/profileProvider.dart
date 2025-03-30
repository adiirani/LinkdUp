import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class ProfileProvider extends ChangeNotifier {
  late String id;
  late String profileImage;
  late String name;
  late String bio;
  late Map<String, String> linkedSocials;
  late List<String> friends;

  Map<String, String> photoCaptions = {};
  List<String> uploadedPhotos = [];

  ProfileProvider({
    String? id,
    String? profileImage,
    String? name,
    String? bio,
    Map<String, String>? linkedSocials,
    List<String>? friends,
    List<String>? uploadedPhotos,
    Map<String, String>? photoCaptions,
  }) {
    this.id = id ?? const Uuid().v4();
    this.profileImage = profileImage ?? '';
    this.name = name ?? '';
    this.bio = bio ?? '';
    this.linkedSocials = linkedSocials ?? {};
    this.friends = friends ?? [];
    this.uploadedPhotos = uploadedPhotos ?? [];
    this.photoCaptions = photoCaptions ?? {};
  }

  /// Load profile from Hive
  static Future<ProfileProvider> loadProfile() async {
    final box = await Hive.openBox('profileBox');
    return ProfileProvider(
      id: box.get('id', defaultValue: const Uuid().v4()),
      name: box.get('name', defaultValue: ''),
      bio: box.get('bio', defaultValue: ''),
      profileImage: box.get('profileImage', defaultValue: ''),
      linkedSocials: Map<String, String>.from(box.get('linkedSocials', defaultValue: {})),
      friends: List<String>.from(box.get('friends', defaultValue: [])),
      uploadedPhotos: List<String>.from(box.get('uploadedPhotos', defaultValue: [])),
      photoCaptions: Map<String, String>.from(
        box.get('photoCaptions', defaultValue: {}),
      ),
    );
  }

  /// Save profile to Hive
  Future<void> saveProfile() async {
    final box = await Hive.openBox('profileBox');
    await box.put('id', id);
    await box.put('name', name);
    await box.put('bio', bio);
    await box.put('profileImage', profileImage);
    await box.put('linkedSocials', linkedSocials);
    await box.put('friends', friends);
    await box.put('uploadedPhotos', uploadedPhotos);
    await box.put('photoCaptions', photoCaptions);
    notifyListeners();
  }

  void updateProfile({String? newName, String? newBio, String? newProfileImage}) {
    if (newName != null) name = newName;
    if (newBio != null) bio = newBio;
    if (newProfileImage != null) profileImage = newProfileImage;
    saveProfile();
    notifyListeners();
  }

  void addLinkedSocial(String platform, String username) {
    linkedSocials[platform] = username;
    saveProfile();
  }

  void removeLinkedSocial(String platform) {
    linkedSocials.remove(platform);
    saveProfile();
  }

  void addFriend(String friendId) {
    if (!friends.contains(friendId)) {
      friends.add(friendId);
      saveProfile();
    }
  }

  void removeFriend(String friendId) {
    friends.remove(friendId);
    saveProfile();
  }

  /// ✅ Gallery methods
  void addPhoto(String path) {
    uploadedPhotos.add(path);
    saveProfile();
  }

  void removePhoto(int index) {
    uploadedPhotos.removeAt(index);
    saveProfile();
  }

  void reorderPhotos(int oldIndex, int newIndex) {
    final photo = uploadedPhotos.removeAt(oldIndex);
    uploadedPhotos.insert(newIndex, photo);
    saveProfile();
  }

  void updateCaption(String path, String caption) {
    photoCaptions[path] = caption;
    saveProfile();
    notifyListeners();
  }
}

