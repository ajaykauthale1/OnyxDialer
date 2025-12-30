import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/t9_engine.dart';
import '../../services/native_bridge.dart';

// Simple provider for the T9 engine (mocked for now, normally would load contacts)
final t9EngineProvider = Provider<T9Engine>((ref) {
  final engine = T9Engine();
  // TODO: Load real contacts here
  engine.insert('Mom', '1234567890');
  engine.insert('Dad', '0987654321');
  return engine;
});

final nativeBridgeProvider = Provider<NativeBridge>((ref) => NativeBridge());

class KeypadScreen extends ConsumerStatefulWidget {
  const KeypadScreen({super.key});

  @override
  ConsumerState<KeypadScreen> createState() => _KeypadScreenState();
}

class _KeypadScreenState extends ConsumerState<KeypadScreen> {
  String _input = '';
  List<ContactMatch> _matches = [];

  void _onKeyPress(String key) {
    setState(() {
      _input += key;
      _matches = ref.read(t9EngineProvider).search(_input);
    });
  }

  void _onBackspace() {
    if (_input.isNotEmpty) {
      setState(() {
        _input = _input.substring(0, _input.length - 1);
        _matches = ref.read(t9EngineProvider).search(_input);
      });
    }
  }

  void _onLongPress(String key) {
    // Phase 3.1: Speed Dial Logic (Placeholder)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Speed Dial for $key not set')),
    );
  }

  void _call() {
    if (_input.isNotEmpty) {
      ref.read(nativeBridgeProvider).makeCall(_input);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keypad')),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _input,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                if (_matches.isNotEmpty)
                  Text(
                    'Top Match: ${_matches.first.name}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
              ],
            ),
          ),
          
          // Keypad Grid
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              padding: const EdgeInsets.all(16),
              children: [
                _buildKey('1', ''),
                _buildKey('2', 'ABC'),
                _buildKey('3', 'DEF'),
                _buildKey('4', 'GHI'),
                _buildKey('5', 'JKL'),
                _buildKey('6', 'MNO'),
                _buildKey('7', 'PQRS'),
                _buildKey('8', 'TUV'),
                _buildKey('9', 'WXYZ'),
                _buildKey('*', ''),
                _buildKey('0', '+'),
                _buildKey('#', ''),
              ],
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.video_call, size: 32),
                  onPressed: () {}, // Placeholder
                ),
                FloatingActionButton(
                  onPressed: _call,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.call),
                ),
                IconButton(
                  icon: const Icon(Icons.backspace, size: 32),
                  onPressed: _onBackspace,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String digit, String letters) {
    return GestureDetector(
      onLongPress: () => _onLongPress(digit),
      child: InkWell(
        onTap: () => _onKeyPress(digit),
        borderRadius: BorderRadius.circular(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(digit, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            if (letters.isNotEmpty)
              Text(letters, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
