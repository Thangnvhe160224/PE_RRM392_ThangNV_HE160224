import 'package:course_sqlite/main.dart';
import 'package:course_sqlite/models/expense.dart';
import 'package:course_sqlite/repositories/expense_repository.dart';
import 'package:course_sqlite/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeExpenseRepository implements ExpenseRepository {
  final List<Expense> expenses = [
    Expense(
      id: 1,
      name: 'Ăn uống',
      amount: 150000,
      category: 'Sinh hoạt',
      date: DateTime(2026, 10, 29),
    ),
  ];

  @override
  Future<List<Expense>> getExpenses() async => List.of(expenses);

  @override
  Future<Expense?> getExpenseById(int id) async =>
      expenses.where((e) => e.id == id).firstOrNull;

  @override
  Future<void> updateExpense(Expense expense) async {
    final index = expenses.indexWhere((e) => e.id == expense.id);
    expenses[index] = expense;
  }
}

void main() {
  late FakeExpenseRepository repository;

  Future<void> pumpApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          expenseRepositoryProvider.overrideWithValue(repository),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  setUp(() => repository = FakeExpenseRepository());

  testWidgets('1. hiển thị danh sách chi tiêu', (tester) async {
    await pumpApp(tester);

    expect(find.text('Ăn uống'), findsOneWidget);
    expect(find.text('Sinh hoạt'), findsOneWidget);
    expect(find.text('29/10/2026'), findsOneWidget);
    expect(find.text('150,000 VND'), findsOneWidget);
  });

  testWidgets('2. bấm Edit, sửa số tiền, Lưu thì danh sách đổi', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.text('Chỉnh sửa khoản chi'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), '200000');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('200,000 VND'), findsOneWidget);
    expect(repository.expenses.first.amount, 200000);
  });

  testWidgets('3. chọn USD trong hộp thoại thì số tiền đổi sang USD', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await tester.tap(find.text('USD (Đô la Mỹ)'));
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();

    expect(find.text('6.00 USD'), findsOneWidget);
  });
}
