import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

// part 'app_database.g.dart'; // Commented out to allow compilation without build_runner

// Manual definitions for compilation
class GhostContact {
  final int id;
  final String firstName;
  final String? lastName;
  final String number;

  GhostContact({required this.id, required this.firstName, this.lastName, required this.number});
}

class GhostCallLog {
  final int id;
  final String number;
  final int type;
  final int duration;
  final DateTime timestamp;

  GhostCallLog({required this.id, required this.number, required this.type, required this.duration, required this.timestamp});
}

class GhostContacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text().nullable()();
  TextColumn get number => text()();
}

class GhostCallLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text()();
  IntColumn get type => integer()(); 
  IntColumn get duration => integer()();
  DateTimeColumn get timestamp => dateTime()();
}

// @DriftDatabase(tables: [GhostContacts, GhostCallLogs])
class AppDatabase { // Removed extends _$AppDatabase
  // AppDatabase() : super(_openConnection());
  
  // @override
  // int get schemaVersion => 1;
}

/*
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'onyx_vault.db'));

    return NativeDatabase(
      file,
      setup: (database) {
        database.execute("PRAGMA key = 'secret_key_123';");
      },
    );
  });
}
*/
