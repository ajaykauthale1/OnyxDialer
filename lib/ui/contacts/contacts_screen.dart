import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../services/contact_service.dart';
import '../../services/native_bridge.dart';
import 'contact_search_delegate.dart';

final nativeBridgeProvider = Provider<NativeBridge>((ref) => NativeBridge());

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              contactsAsync.whenData((contacts) {
                showSearch(
                  context: context,
                  delegate: ContactSearchDelegate(contacts, ref.read(nativeBridgeProvider)),
                );
              });
            },
          ),
        ],
      ),
      body: contactsAsync.when(
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(child: Text('No contacts found'));
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              final hasPhone = contact.phones.isNotEmpty;
              return ListTile(
                leading: (contact.photo != null) 
                    ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(contact.displayName),
                subtitle: hasPhone ? Text(contact.phones.first.number) : null,
                onTap: hasPhone ? () {
                  ref.read(nativeBridgeProvider).makeCall(contact.phones.first.number);
                } : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
