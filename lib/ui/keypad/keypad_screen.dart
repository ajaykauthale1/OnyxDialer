import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/t9_engine.dart';
import '../../services/native_bridge.dart';
import '../../providers/god_mode_provider.dart';
import '../../services/contact_service.dart';
import '../contacts/contact_search_delegate.dart';

// Simple provider for the T9 engine (mocked for now, normally would load contacts)
final t9EngineProvider = Provider<T9Engine>((ref) {
  final engine = T9Engine();
  // Contacts are loaded into the engine by contactListProvider
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
    _checkTrigger();
  }

  void _checkTrigger() {
    // Trigger: *#0000#
    if (_input == '*#0000#') {
      ref.read(godModeProvider.notifier).unlock();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('God Mode Activated'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _input = '';
        _matches = [];
      });
    }
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

  void _onMatchTap(ContactMatch match) {
    // Fill input with number and maybe call?
    // For now, just fill input
    setState(() {
      _input = match.number;
      _matches = []; // Clear matches as we selected one
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Options Bar (Add Contact / Search)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_input.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        // TODO: Add to contacts logic
                      },
                      icon: const Icon(Icons.person_add, size: 20),
                      label: const Text('Add to Contacts'),
                      style: TextButton.styleFrom(foregroundColor: Colors.green),
                    )
                  else
                    const SizedBox(), // Spacer
                    
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      ref.read(contactListProvider).whenData((contacts) {
                        showSearch(
                          context: context,
                          delegate: ContactSearchDelegate(contacts, ref.read(nativeBridgeProvider)),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),

            // Display Area (List + Input)
            Expanded(
              flex: 3, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Push content to bottom
                children: [
                  // Search Results List
                  if (_matches.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _matches.length,
                        itemBuilder: (context, index) {
                          final match = _matches[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(match.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(match.number),
                            onTap: () => _onMatchTap(match),
                            trailing: IconButton(
                              icon: const Icon(Icons.call, color: Colors.green),
                              onPressed: () {
                                ref.read(nativeBridgeProvider).makeCall(match.number);
                              },
                            ),
                          );
                        },
                      ),
                    )
                  else
                    const Spacer(), // Push input down if no list

                  // The Input Number
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _input,
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            
            // Keypad Grid
            Expanded(
              flex: 5, 
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 1.6, 
                  mainAxisSpacing: 16, 
                  crossAxisSpacing: 24, 
                  physics: const NeverScrollableScrollPhysics(),
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
            ),
            
            // Action Buttons (Call / Backspace)
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0, top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Video Call / Left Option
                  IconButton(
                    icon: const Icon(Icons.video_call, size: 28),
                    color: Colors.grey,
                    onPressed: () {}, 
                  ),
                  
                  // Call Button
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: FloatingActionButton(
                      onPressed: _call,
                      backgroundColor: Colors.green,
                      elevation: 4,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.call, size: 36, color: Colors.white),
                    ),
                  ),
                  
                  // Backspace
                  IconButton(
                    icon: const Icon(Icons.backspace, size: 28),
                    color: Colors.grey,
                    onPressed: _onBackspace,
                  ),
                ],
              ),
            ),
          ],
        ),
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
            Text(digit, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
            if (letters.isNotEmpty)
              Text(letters, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.5)),
          ],
        ),
      ),
    );
  }
}
