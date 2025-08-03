class Account {
  final int? id;
  final String name;
  final String type; // 'cash', 'bank', 'credit', 'investment'
  final double balance;
  final String? bankName;
  final String? accountNumber;
  final String? color;

  Account({
    this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.bankName,
    this.accountNumber,
    this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'color': color,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      balance: map['balance'],
      bankName: map['bankName'],
      accountNumber: map['accountNumber'],
      color: map['color'],
    );
  }
} 