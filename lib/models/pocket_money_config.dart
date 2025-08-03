class PocketMoneyConfig {
  final String id;
  final String memberId;
  final double dailyAmount; // 日零花钱
  final bool accumulateToNext; // 是否累计到下期
  final DateTime startDate; // 开始时间
  final DateTime? endDate;
  final bool isEnabled; // 是否启用零花钱功能
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PocketMoneyConfig({
    required this.id,
    required this.memberId,
    required this.dailyAmount,
    required this.accumulateToNext,
    required this.startDate,
    this.endDate,
    required this.isEnabled,
    this.createdAt,
    this.updatedAt,
  });

  PocketMoneyConfig copyWith({
    String? id,
    String? memberId,
    double? dailyAmount,
    bool? accumulateToNext,
    DateTime? startDate,
    DateTime? endDate,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PocketMoneyConfig(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      dailyAmount: dailyAmount ?? this.dailyAmount,
      accumulateToNext: accumulateToNext ?? this.accumulateToNext,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 