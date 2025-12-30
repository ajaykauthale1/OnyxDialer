import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 't9_engine.dart';
import '../ui/keypad/keypad_screen.dart'; // To access t9EngineProvider

final contactListProvider = FutureProvider<List<Contact>>((ref) async {
  // 1. Request Permission
  if (!await FlutterContacts.requestPermission(readonly: true)) {
    return [];
  }

  // 2. Fetch Contacts (with properties)
  final contacts = await FlutterContacts.getContacts(withProperties: true);

  // 3. Feed T9 Engine
  final t9Engine = ref.read(t9EngineProvider);
  for (var contact in contacts) {
    if (contact.phones.isNotEmpty) {
      // Use the first number for simplicity, or iterate all
      for (var phone in contact.phones) {
        t9Engine.insert(contact.displayName, phone.number);
      }
    }
  }

  return contacts;
});
