class AnnualActivity {
  final String id;
  final String userId;
  final int year;
  final Map<String, double> dailyExpenses; // 日期 -> 支出金额
  final double totalExpense; // 年度总支出
  final double averageDailyExpense; // 平均日支出
  final double maxDailyExpense; // 最高日支出
  final int expenseDays; // 有支出的天数
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AnnualActivity({
    required this.id,
    required this.userId,
    required this.year,
    required this.dailyExpenses,
    required this.totalExpense,
    required this.averageDailyExpense,
    required this.maxDailyExpense,
    required this.expenseDays,
    this.createdAt,
    this.updatedAt,
  });

  AnnualActivity copyWith({
    String? id,
    String? userId,
    int? year,
    Map<String, double>? dailyExpenses,
    double? totalExpense,
    double? averageDailyExpense,
    double? maxDailyExpense,
    int? expenseDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AnnualActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      year: year ?? this.year,
      dailyExpenses: dailyExpenses ?? this.dailyExpenses,
      totalExpense: totalExpense ?? this.totalExpense,
      averageDailyExpense: averageDailyExpense ?? this.averageDailyExpense,
      maxDailyExpense: maxDailyExpense ?? this.maxDailyExpense,
      expenseDays: expenseDays ?? this.expenseDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AnnualActivityConfig {
  final String id;
  final String userId;
  final List<double> expenseLevels; // 支出等级阈值
  final List<String> levelColors; // 等级对应颜色
  final bool showIncome; // 是否显示收入
  final bool showMembers; // 是否显示成员
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AnnualActivityConfig({
    required this.id,
    required this.userId,
    required this.expenseLevels,
    required this.levelColors,
    required this.showIncome,
    required this.showMembers,
    this.createdAt,
    this.updatedAt,
  });
} 