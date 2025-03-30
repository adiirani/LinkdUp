import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage'),
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