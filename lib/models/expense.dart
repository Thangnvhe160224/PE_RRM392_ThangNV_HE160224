/// Một dòng trong bảng `expenses` của SQLite.
class Expense {
  final int? id; // null khi chưa lưu vào database
  final String name;

  /// Số tiền luôn lưu bằng VND; lúc hiển thị mới đổi sang đơn vị đã chọn.
  final int amount;
  final String category;
  final DateTime date;

  const Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Đọc 1 dòng SQLite (Map) thành object.
  // Ngày lưu dạng chữ 'yyyy-MM-dd' nên dùng DateTime.parse.
  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int,
      name: map['name'] as String,
      amount: map['amount'] as int,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  // Đổi object thành Map để ghi vào SQLite
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String().substring(0, 10),
    };
  }

  Expense copyWith({
    String? name,
    int? amount,
    String? category,
    DateTime? date,
  }) {
    return Expense(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}

/// Các danh mục trong ô chọn "Danh mục" ở màn sửa.
const expenseCategories = [
  'Sinh hoạt',
  'Đi lại',
  'Học tập',
  'Sức khỏe',
  'Giải trí',
];
