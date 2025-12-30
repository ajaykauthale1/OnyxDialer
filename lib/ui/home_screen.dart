import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'keypad/keypad_screen.dart';
import 'recents/recents_screen.dart';
import 'contacts/contacts_screen.dart';
import 'settings/settings_screen.dart';
import 'vault/vault_screen.dart';
import '../providers/god_mode_provider.dart';
import '../services/contact_service.dart';

// Using Notifier instead of StateProvider for better compatibility
class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 1; // Default to Keypad (index 1)

  void setIndex(int index) {
    state = index;
  }
}

final bottomNavIndexProvider = NotifierProvider<BottomNavIndexNotifier, int>(BottomNavIndexNotifier.new);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final isGodMode = ref.watch(godModeProvider);
    
    // Trigger contact loading to populate T9 engine
    ref.watch(contactListProvider);

    final screens = [
      const RecentsScreen(),
      const KeypadScreen(),
      const ContactsScreen(),
      if (isGodMode) const VaultScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isGodMode ? 'Onyx (Unlocked)' : 'Onyx'),
        backgroundColor: isGodMode ? Colors.red.withOpacity(0.2) : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.access_time),
            label: 'Recents',
          ),
          const NavigationDestination(
            icon: Icon(Icons.dialpad),
            label: 'Keypad',
          ),
          const NavigationDestination(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          if (isGodMode)
            const NavigationDestination(
              icon: Icon(Icons.security, color: Colors.red),
              label: 'Vault',
            ),
        ],
      ),
    );
  }
}
