import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/god_mode_provider.dart';
import '../../services/native_bridge.dart';

final nativeBridgeProvider = Provider<NativeBridge>((ref) => NativeBridge());

class ContactInfoScreen extends ConsumerWidget {
  final Contact contact;

  const ContactInfoScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGodMode = ref.watch(godModeProvider);
    final hasPhone = contact.phones.isNotEmpty;
    final phoneNumber = hasPhone ? contact.phones.first.number : 'No Number';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Info'),
        actions: [
          IconButton(icon: const Icon(Icons.star_border), onPressed: () {}),
          IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Header
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: contact.photo != null ? MemoryImage(contact.photo!) : null,
            child: contact.photo == null ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 16),
          Text(
            contact.displayName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            phoneNumber,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Action Row (Call, Message, Video)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.call, 'Call', () {
                if (hasPhone) ref.read(nativeBridgeProvider).makeCall(phoneNumber);
              }),
              _buildActionButton(Icons.message, 'Message', () {}),
              _buildActionButton(Icons.videocam, 'Video', () {}),
            ],
          ),
          const Divider(height: 40),

          // Details List
          Expanded(
            child: ListView(
              children: [
                const ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Call History'),
                  subtitle: Text('No recent calls'),
                ),
                const ListTile(
                  leading: Icon(Icons.storage),
                  title: Text('Storage Location'),
                  subtitle: Text('Phone / Google'), // Placeholder
                ),
                if (isGodMode) ...[
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security, color: Colors.red),
                    title: const Text('Move to Vault', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      // TODO: Implement move to vault logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Moved to Vault (Simulated)')),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
            IconButton(icon: const Icon(Icons.block), onPressed: () {}),
            if (isGodMode)
              IconButton(icon: const Icon(Icons.delete_forever, color: Colors.red), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label, // Unique tag
          onPressed: onPressed,
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
