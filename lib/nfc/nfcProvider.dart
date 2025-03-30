import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:rizzlr/models/profileProvider.dart';
import 'package:rizzlr/models/friendProvider.dart';

class NfcProvider extends ChangeNotifier {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  late ProfileProvider currentUserProfile;
  bool isScanning = false;

  NfcProvider(this.currentUserProfile);

  // Start scanning NFC tags
  void startScanning() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final tagData = tag.data;
        // Assume the profile is encoded in the NFC tag as JSON
        String userProfileJson = utf8.decode(tagData["raw"]);
        Map<String, dynamic> userMap = jsonDecode(userProfileJson);
        _addFriend(userMap);
      },
    );
    isScanning = true;
    notifyListeners();
  }

  // Stop scanning NFC tags
  void stopScanning() {
    NfcManager.instance.stopSession();
    isScanning = false;
    notifyListeners();
  }

  // Add friend to the current user's list (convert profile to friend)
  Future<void> _addFriend(Map<String, dynamic> userMap) async {
    // Convert user profile from NFC tag to ProfileProvider
    ProfileProvider scannedProfile = ProfileProvider(
      id: userMap["id"],
      name: userMap["name"],
      bio: userMap["bio"],
      profileImage: userMap["profileImage"],
      linkedSocials: Map<String, String>.from(userMap["linkedSocials"]),
      friends: List<String>.from(userMap["friends"]),
    );

    // Convert scanned profile to FriendProvider
    FriendProvider friend = FriendProvider.fromProfile(scannedProfile);
    
    // Add friend to current user's list
    currentUserProfile.addFriend(friend.id);

    // Convert current user to FriendProvider and add to scanned user's friend list
    FriendProvider currentFriend = FriendProvider.fromProfile(currentUserProfile);
    scannedProfile.addFriend(currentFriend.id);

    // Save both profiles to their respective Hive boxes
    await currentUserProfile.saveProfile();
    await scannedProfile.saveProfile();

    // Notify the user that the trade was successful
    _showSuccessNotification(friend.name);
  }

  // Show success notification after adding a friend
  Future<void> _showSuccessNotification(String friendName) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var androidDetails = AndroidNotificationDetails(
      'friend_trade_channel',
      'Friend Trade',
      channelDescription: 'Channel for friend trade notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Friend Added',
      'You are now friends with $friendName!',
      generalNotificationDetails,
    );
  }
}
