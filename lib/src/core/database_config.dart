import 'package:new_brunner_app/src/core/ConfigDatabase/modulos_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await getDatabase();

  Future<Database> getDatabase() async {
    final String path = join(await getDatabasesPath(), 'brunner.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute(ModulosDB.modulosTableSql);
      db.execute(ModulosDB.submodulosTableSql);
    }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
  }
}
