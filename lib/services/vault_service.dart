import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

class VaultService {
  final AppDatabase _db;

  VaultService(this._db);

  // Contacts
  Future<int> addContact(String firstName, String number) {
    return _db.into(_db.ghostContacts).insert(GhostContactsCompanion.insert(
      firstName: firstName,
      number: number,
    ));
  }

  Future<List<GhostContact>> getAllContacts() {
    return _db.select(_db.ghostContacts).get();
  }

  // Call Logs
  Future<int> addCallLog(String number, int type, int duration) {
    return _db.into(_db.ghostCallLogs).insert(GhostCallLogsCompanion.insert(
      number: number,
      type: type,
      duration: duration,
      timestamp: DateTime.now(),
    ));
  }

  Future<List<GhostCallLog>> getAllCallLogs() {
    return _db.select(_db.ghostCallLogs).get();
  }
}

final vaultServiceProvider = Provider<VaultService>((ref) {
  final db = ref.watch(databaseProvider);
  return VaultService(db);
});
