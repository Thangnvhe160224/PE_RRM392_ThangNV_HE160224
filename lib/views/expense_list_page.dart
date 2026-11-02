import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency.dart';
import '../models/expense.dart';
import '../utils/formatters.dart';
import '../viewmodels/expense_view_model.dart';
import '../viewmodels/settings_view_model.dart';
import 'expense_edit_page.dart';

class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesState = ref.watch(expenseViewModelProvider);
    final currency = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý chi tiêu'),
        actions: [
          IconButton(
            tooltip: 'Đơn vị tiền tệ',
            icon: const Icon(Icons.settings),
            onPressed: () => _showCurrencyDialog(context, ref, currency),
          ),
        ],
      ),
      body: expensesState.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(child: Text('Chưa có khoản chi nào'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: expenses.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _ExpenseTile(expense: expenses[index], currency: currency),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Lỗi: $error')),
      ),
    );
  }

  Future<void> _showCurrencyDialog(
    BuildContext context,
    WidgetRef ref,
    Currency current,
  ) async {
    final selected = await showDialog<Currency>(
      context: context,
      builder: (context) {
        var choice = current;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Đơn vị tiền tệ'),
            content: RadioGroup<Currency>(
              groupValue: choice,
              onChanged: (value) => setState(() => choice = value!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final currency in Currency.values)
                    RadioListTile<Currency>(
                      value: currency,
                      title: Text(currency.label),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, choice),
                child: const Text('Lưu'),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      await ref.read(settingsViewModelProvider.notifier).setCurrency(selected);
    }
  }
}

class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  final Currency currency;

  const _ExpenseTile({required this.expense, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Chip(
                    label: Text(expense.category),
                    labelStyle: const TextStyle(fontSize: 12),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatDate(expense.date),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  formatMoney(expense.amount, currency),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              tooltip: 'Sửa',
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseEditPage(expense: expense),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
