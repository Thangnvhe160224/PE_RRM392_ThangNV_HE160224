import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense.dart';
import '../utils/formatters.dart';
import '../viewmodels/expense_view_model.dart';

class ExpenseEditPage extends ConsumerStatefulWidget {
  final Expense expense;

  const ExpenseEditPage({super.key, required this.expense});

  @override
  ConsumerState<ExpenseEditPage> createState() => _ExpenseEditPageState();
}

class _ExpenseEditPageState extends ConsumerState<ExpenseEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.expense.name);
  late final _amountController = TextEditingController(
    text: widget.expense.amount.toString(),
  );
  late String _category = widget.expense.category;
  late DateTime _date = widget.expense.date;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final updated = widget.expense.copyWith(
      name: _nameController.text.trim(),
      amount: int.parse(_amountController.text),
      category: _category,
      date: _date,
    );
    await ref.read(expenseViewModelProvider.notifier).updateExpense(updated);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(expenseViewModelProvider.notifier);
    final categories = {...expenseCategories, widget.expense.category};

    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa khoản chi')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _FieldLabel('Tên khoản chi *'),
              TextFormField(
                controller: _nameController,
                validator: viewModel.validateName,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Số tiền *'),
              TextFormField(
                controller: _amountController,
                validator: viewModel.validateAmount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Danh mục *'),
              DropdownButtonFormField<String>(
                initialValue: _category,
                items: [
                  for (final category in categories)
                    DropdownMenuItem(value: category, child: Text(category)),
                ],
                onChanged: (value) => setState(() => _category = value!),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Ngày chi tiêu *'),
              // Ô chỉ để hiện ngày; bấm vào thì mở lịch
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(formatDate(_date)),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _save,
                      child: const Text('Lưu'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
