class Budget {
  final String id;
  final String name;
  final String type; // daily, weekly, monthly, yearly, category
  final double amount; // 预算金额
  final double usedAmount; // 已使用金额
  final String period; // 预算周期
  final bool accumulateToNext; // 是否累计到下期
  final double warningThreshold; // 预警阈值
  final bool isActive; // 是否激活
  final String? categoryId; // 分类预算关联的分类
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Budget({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.usedAmount,
    required this.period,
    required this.accumulateToNext,
    required this.warningThreshold,
    required this.isActive,
    this.categoryId,
    required this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  Budget copyWith({
    String? id,
    String? name,
    String? type,
    double? amount,
    double? usedAmount,
    String? period,
    bool? accumulateToNext,
    double? warningThreshold,
    bool? isActive,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Budget(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      usedAmount: usedAmount ?? this.usedAmount,
      period: period ?? this.period,
      accumulateToNext: accumulateToNext ?? this.accumulateToNext,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BudgetUsage {
  final String id;
  final String budgetId;
  final String transactionId;
  final double amount; // 使用金额
  final DateTime date;
  final DateTime? createdAt;

  const BudgetUsage({
    required this.id,
    required this.budgetId,
    required this.transactionId,
    required this.amount,
    required this.date,
    this.createdAt,
  });
} 