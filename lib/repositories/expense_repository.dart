import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/expense.dart';
import '../services/database_service.dart';

part 'expense_repository.g.dart';

@Riverpod(keepAlive: true)
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepository(ref.watch(databaseServiceProvider));
}

class ExpenseRepository {
  final DatabaseService _databaseService;

  ExpenseRepository(this._databaseService);

  Future<List<Expense>> getExpenses() async {
    final db = await _databaseService.database;
    final rows = await db.query('expenses', orderBy: 'date DESC, id DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<Expense?> getExpenseById(int id) async {
    final db = await _databaseService.database;
    final rows = await db.query('expenses', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Expense.fromMap(rows.first);
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await _databaseService.database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
}
