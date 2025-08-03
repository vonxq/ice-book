class PocketMoneyRecord {
  final String id;
  final String memberId;
  final double amount;
  final String type; // daily, reward, expense, penalty
  final String? transactionId; // 关联的交易记录
  final String note; // 备注信息
  final DateTime date;
  final DateTime? createdAt;

  const PocketMoneyRecord({
    required this.id,
    required this.memberId,
    required this.amount,
    required this.type,
    this.transactionId,
    required this.note,
    required this.date,
    this.createdAt,
  });

  PocketMoneyRecord copyWith({
    String? id,
    String? memberId,
    double? amount,
    String? type,
    String? transactionId,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return PocketMoneyRecord(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      transactionId: transactionId ?? this.transactionId,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 