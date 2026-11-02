import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/expense.dart';
import '../repositories/expense_repository.dart';

part 'expense_view_model.g.dart';

@riverpod
class ExpenseViewModel extends _$ExpenseViewModel {
  @override
  Future<List<Expense>> build() async {
    return ref.read(expenseRepositoryProvider).getExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    final repository = ref.read(expenseRepositoryProvider);
    await repository.updateExpense(expense);
    final expenses = await repository.getExpenses();
    if (!ref.mounted) return;
    state = AsyncData(expenses);
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên khoản chi';
    }
    return null;
  }

  String? validateAmount(String? value) {
    final amount = int.tryParse(value ?? '');
    if (amount == null || amount <= 0) {
      return 'Số tiền phải là số nguyên lớn hơn 0';
    }
    return null;
  }
}
