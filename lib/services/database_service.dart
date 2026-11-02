import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'database_service.g.dart';

@Riverpod(keepAlive: true)
DatabaseService databaseService(Ref ref) {
  return DatabaseService();
}

class DatabaseService {
  static const _fileName = 'expense.db';
  static const _version = 1;
  final String? _path;
  Database? _database;
  DatabaseService({String? path}) : _path = path;
  Future<Database> get database async {
    _database ??= await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final path = _path ?? join(await getDatabasesPath(), _fileName);
    return openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount INTEGER NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    const seed = [
      ['Ăn uống', 150000, 'Sinh hoạt', '2026-10-29'],
      ['Di chuyển', 50000, 'Đi lại', '2026-10-28'],
      ['Mua sách', 200000, 'Học tập', '2026-10-27'],
      ['Mua sắm', 1500000, 'Sinh hoạt', '2026-10-25'],
      ['Khám bệnh', 3550000, 'Sức khỏe', '2026-10-22'],
    ];
    for (final row in seed) {
      await db.insert('expenses', {
        'name': row[0],
        'amount': row[1],
        'category': row[2],
        'date': row[3],
      });
    }
  }
}
