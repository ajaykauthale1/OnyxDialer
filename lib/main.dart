import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: OnyxDialerApp()));
}

class OnyxDialerApp extends StatelessWidget {
  const OnyxDialerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onyx Dialer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Onyx Dialer - Phase 1 Initialized'),
        ),
      ),
    );
  }
}
