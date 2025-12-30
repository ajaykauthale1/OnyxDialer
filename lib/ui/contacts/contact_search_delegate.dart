import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../services/native_bridge.dart';
import 'contact_info_screen.dart';

class ContactSearchDelegate extends SearchDelegate {
  final List<Contact> contacts;
  final NativeBridge nativeBridge;

  ContactSearchDelegate(this.contacts, this.nativeBridge);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final results = contacts.where((contact) {
      return contact.displayName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final contact = results[index];
        final hasPhone = contact.phones.isNotEmpty;
        return ListTile(
          leading: (contact.photo != null)
              ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
              : const CircleAvatar(child: Icon(Icons.person)),
          title: Text(contact.displayName),
          subtitle: hasPhone ? Text(contact.phones.first.number) : null,
          onTap: hasPhone
              ? () {
                  // Instead of calling directly, show options
                  _showContactOptions(context, contact);
                }
              : null,
        );
      },
    );
  }

  void _showContactOptions(BuildContext context, Contact contact) {
    close(context, null); // Close the search delegate first
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Call'),
              onTap: () {
                nativeBridge.makeCall(contact.phones.first.number);
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Message'),
              onTap: () {
                // TODO: Implement SMS intent
                Navigator.of(ctx).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Video Call'),
              onTap: () {
                // TODO: Implement Video Call intent
                Navigator.of(ctx).pop();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Info'),
              onTap: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ContactInfoScreen(contact: contact),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
