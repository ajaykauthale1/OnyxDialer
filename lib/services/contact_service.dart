import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 't9_engine.dart';

final contactServiceProvider = Provider<ContactService>((ref) => ContactService());

class ContactService {
  Future<bool> requestPermission() async {
    return await FlutterContacts.requestPermission(readonly: true);
  }

  Future<List<Contact>> getContacts() async {
    if (await FlutterContacts.requestPermission(readonly: true)) {
      return await FlutterContacts.getContacts(withProperties: true, withPhoto: false);
    }
    return [];
  }

  Future<void> loadContactsToT9(T9Engine engine) async {
    final contacts = await getContacts();
    for (var contact in contacts) {
      final name = contact.displayName;
      if (contact.phones.isNotEmpty) {
        for (var phone in contact.phones) {
          // Normalize number (remove spaces, dashes, etc.)
          final number = phone.number.replaceAll(RegExp(r'[^\d+]'), '');
          engine.insert(name, number);
        }
      }
    }
  }
}
