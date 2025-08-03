class Transaction {
  final String id;
  final String userId;
  final String accountId;
  final String categoryId;
  final double amount;
  final String type; // income, expense
  final String note;
  final DateTime date;
  final String? budgetId;
  final DateTime? createdAt;

  const Transaction({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
    this.budgetId,
    this.createdAt,
  });

  Transaction copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? categoryId,
    double? amount,
    String? type,
    String? note,
    DateTime? date,
    String? budgetId,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      note: note ?? this.note,
      date: date ?? this.date,
      budgetId: budgetId ?? this.budgetId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TransactionContributor {
  final String id;
  final String transactionId;
  final String memberId;
  final double amount;
  final String type; // income, expense
  final DateTime? createdAt;

  const TransactionContributor({
    required this.id,
    required this.transactionId,
    required this.memberId,
    required this.amount,
    required this.type,
    this.createdAt,
  });
} 