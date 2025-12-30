import 'package:flutter/material.dart';

class RecentsScreen extends StatelessWidget {
  const RecentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recents')),
      body: const Center(
        child: Text('Call History will appear here'),
      ),
    );
  }
}
