import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rizzlr/theme/themeprov.dart';
import 'package:rizzlr/components/gradientBox.dart';
import 'package:rizzlr/components/neumorphicboxthin.dart'; // NeuBoxThin component

class BluetoothPingScreen extends StatefulWidget {
  @override
  _BluetoothPingScreenState createState() => _BluetoothPingScreenState();
}

class _BluetoothPingScreenState extends State<BluetoothPingScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<Map<String, dynamic>> nearbyUsers = [];
  bool isScanning = false;

  void _toggleScanning() {
    if (isScanning) {
      _stopScanning();
    } else {
      _startScanning();
    }
  }

  void _startScanning() {
    setState(() {
      isScanning = true;
      nearbyUsers.clear(); // Clear previous users and add "You"
      nearbyUsers.add({'name': 'You', 'distance': 0.0});
    });

    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        String name = r.device.name.isNotEmpty ? r.device.name : "Unknown";
        double distance = _calculateDistance(r.rssi);

        String? userInfo;
        if (r.advertisementData.manufacturerData.isNotEmpty) {
          try {
            var manufacturerData = r.advertisementData.manufacturerData.values.first;
            userInfo = utf8.decode(manufacturerData);
            var userMap = jsonDecode(userInfo);
            name = userMap["username"] ?? name;
          } catch (e) {
            print("Failed to decode user info: $e");
          }
        }

        if (!nearbyUsers.any((user) => user['name'] == name)) {
          setState(() {
            nearbyUsers.add({'name': name, 'distance': distance});
          });
        }
      }
    });
  }

  void _stopScanning() {
    FlutterBluePlus.stopScan();
    setState(() {
      isScanning = false;
      nearbyUsers.removeWhere((user) => user['name'] == 'You'); // Remove "You" when scanning stops
    });
  }

  double _calculateDistance(int rssi) {
    // Approximate distance formula based on RSSI
    int txPower = -59; // Typical RSSI at 1 meter
    return rssi == 0 ? -1.0 : (pow(10.0, (txPower - rssi) / 20.0) as double);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: _toggleScanning,
            child: Container(
              height: screenHeight * 0.3, // External fixed size container
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              child: GradientBox(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi,
                        size: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isScanning ? "Finding friends..." : "Tap to find friends",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: nearbyUsers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: NeuThinBox(
                    child: ListTile(
                      title: Text(nearbyUsers[index]['name']),
                      subtitle: Text(
                        "${nearbyUsers[index]['distance'].toStringAsFixed(2)} meters away",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
