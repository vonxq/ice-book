class Account {
  final String id;
  final String userId;
  final String name;
  final String type; // cash, bank, credit, investment, other
  final String bankName; // 银行名称（银行卡类型）
  final double balance;
  final String icon;
  final String color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Account({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.bankName,
    required this.balance,
    required this.icon,
    required this.color,
    this.createdAt,
    this.updatedAt,
  });

  Account copyWith({
    String? id,
    String? userId,
    String? name,
    String? type,
    String? bankName,
    double? balance,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      bankName: bankName ?? this.bankName,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 