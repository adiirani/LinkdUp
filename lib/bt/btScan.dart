import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPingScreen extends StatefulWidget {
  @override
  _BluetoothPingScreenState createState() => _BluetoothPingScreenState();
}

class _BluetoothPingScreenState extends State<BluetoothPingScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> nearbyDevices = [];

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  /// Request Bluetooth & Location permissions
  Future<void> _requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  /// Start scanning for nearby devices
  void startScanning() {
    FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!nearbyDevices.contains(r.device)) {
          setState(() {
            nearbyDevices.add(r.device);
          });
        }
      }
    });
  }

  /// Stop scanning
  void stopScanning() {
    FlutterBluePlus.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ping Nearby Users")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: startScanning,
            child: Text("Start Scanning"),
          ),
          ElevatedButton(
            onPressed: stopScanning,
            child: Text("Stop Scanning"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nearbyDevices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nearbyDevices[index].name.isNotEmpty
                      ? nearbyDevices[index].name
                      : "Unknown Device"),
                  subtitle: Text(nearbyDevices[index].id.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
