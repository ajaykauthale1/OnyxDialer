import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

class VaultService {
  final AppDatabase _db;
  
  // In-memory storage for prototype/testing without build_runner
  final List<GhostContact> _mockContacts = [];
  final List<GhostCallLog> _mockLogs = [];

  VaultService(this._db);

  // Contacts
  Future<int> addContact(String firstName, String number) async {
    final contact = GhostContact(
      id: _mockContacts.length + 1,
      firstName: firstName,
      number: number,
    );
    _mockContacts.add(contact);
    return contact.id;
  }

  Future<List<GhostContact>> getAllContacts() async {
    return _mockContacts;
  }

  // Call Logs
  Future<int> addCallLog(String number, int type, int duration) async {
    final log = GhostCallLog(
      id: _mockLogs.length + 1,
      number: number,
      type: type,
      duration: duration,
      timestamp: DateTime.now(),
    );
    _mockLogs.add(log);
    return log.id;
  }

  Future<List<GhostCallLog>> getAllCallLogs() async {
    return _mockLogs;
  }
}

final vaultServiceProvider = Provider<VaultService>((ref) {
  final db = ref.watch(databaseProvider);
  return VaultService(db);
});
