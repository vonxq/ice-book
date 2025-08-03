class Transaction {
  final int? id;
  final double amount;
  final String category;
  final String type; // 'income' 或 'expense'
  final String? note;
  final DateTime date;
  final String? account;

  Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.type,
    this.note,
    required this.date,
    this.account,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'type': type,
      'note': note,
      'date': date.toIso8601String(),
      'account': account,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      type: map['type'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      account: map['account'],
    );
  }
} 