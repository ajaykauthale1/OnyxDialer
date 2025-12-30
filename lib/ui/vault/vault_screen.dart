import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../services/vault_service.dart';
import '../../database/app_database.dart'; // Will import generated classes

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen> {
  @override
  Widget build(BuildContext context) {
    final vaultService = ref.watch(vaultServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('The Vault'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.red,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<GhostContact>>( // GhostContact from app_database
        future: vaultService.getAllContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }

          final contacts = snapshot.data ?? [];

          if (contacts.isEmpty) {
            return const Center(
              child: Text(
                'No souls in the vault.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.firstName, style: const TextStyle(color: Colors.white)),
                subtitle: Text(contact.number, style: const TextStyle(color: Colors.grey)),
                leading: const Icon(Icons.security, color: Colors.red),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _importContact,
        label: const Text('Import Soul'),
        icon: const Icon(Icons.person_add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _importContact() async {
    // 1. Request Permission
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permission denied')));
      return;
    }

    // 2. Pick Contact
    final contact = await FlutterContacts.openExternalPick();
    if (contact != null) {
      final name = contact.displayName;
      final number = contact.phones.isNotEmpty ? contact.phones.first.number : '';

      if (number.isEmpty) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contact has no number')));
        return;
      }

      // 3. Add to Vault
      await ref.read(vaultServiceProvider).addContact(name, number);

      // 4. Delete from System (Optional/Dangerous - asking confirmation first)
      if (mounted) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete from System?'),
            content: const Text('Do you want to remove this contact from your public address book?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes')),
            ],
          ),
        );

        if (confirm == true) {
           // Note: flutter_contacts might not support direct deletion by ID easily without full access
           // For now, we just simulate or try if the API allows.
           // FlutterContacts.deleteContact(contact); // This requires fetching full contact first
           
           // Fetch full contact to delete
           final fullContact = await FlutterContacts.getContact(contact.id);
           if (fullContact != null) {
             await fullContact.delete();
             if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleted from System')));
           }
        }
      }
      
      setState(() {}); // Refresh list
    }
  }
}
