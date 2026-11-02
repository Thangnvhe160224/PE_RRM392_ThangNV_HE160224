import 'package:course_sqlite/repositories/expense_repository.dart';
import 'package:course_sqlite/services/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late ExpenseRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() {
    repository = ExpenseRepository(DatabaseService(path: inMemoryDatabasePath));
  });

  test('có 5 khoản chi mẫu, ngày mới nhất nằm trên', () async {
    final expenses = await repository.getExpenses();

    expect(expenses.length, 5);
    expect(expenses.first.name, 'Ăn uống');
    expect(expenses.last.name, 'Khám bệnh');
  });

  test('sửa khoản chi thì đọc lại thấy dữ liệu mới', () async {
    final first = (await repository.getExpenses()).first;

    await repository.updateExpense(
      first.copyWith(amount: 99000, category: 'Giải trí'),
    );

    final updated = await repository.getExpenseById(first.id!);
    expect(updated!.amount, 99000);
    expect(updated.category, 'Giải trí');
  });
}
