import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

part 'app_database.g.dart';

class GhostContacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text().nullable()();
  TextColumn get number => text()();
  // Add other fields as needed
}

class GhostCallLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text()();
  IntColumn get type => integer()(); // Incoming, Outgoing, Missed
  IntColumn get duration => integer()();
  DateTimeColumn get timestamp => dateTime()();
}

@DriftDatabase(tables: [GhostContacts, GhostCallLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'onyx_vault.db'));

    return NativeDatabase(
      file,
      setup: (database) {
        // Phase 4.2: SQLCipher Encryption
        // Ideally, the password should be derived from the user's PIN.
        // For now, we use a hardcoded key for the prototype.
        database.execute("PRAGMA key = 'secret_key_123';");
      },
    );
  });
}
