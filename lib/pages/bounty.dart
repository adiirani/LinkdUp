import 'package:flutter/material.dart';

class Bounty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LB'),
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