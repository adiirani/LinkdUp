import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boilerplate Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}