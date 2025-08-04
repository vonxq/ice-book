class PocketMoneyConfig {
  final String id;
  final String memberId;
  final double dailyAmount; // 日零花钱
  final bool accumulateToNext; // 是否累计到下期
  final DateTime startDate; // 开始时间
  final DateTime? endDate; // 结束时间，null表示永久有效
  final bool isEnabled; // 是否启用零花钱功能
  final DateTime createdAt;
  final DateTime updatedAt;

  const PocketMoneyConfig({
    required this.id,
    required this.memberId,
    required this.dailyAmount,
    required this.accumulateToNext,
    required this.startDate,
    this.endDate,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  // 检查时间是否重叠
  bool overlapsWith(PocketMoneyConfig other) {
    if (other.id == id) return false; // 同一个配置
    
    final thisEnd = endDate ?? DateTime.now().add(const Duration(days: 365 * 10)); // 10年后
    final otherEnd = other.endDate ?? DateTime.now().add(const Duration(days: 365 * 10));
    
    return startDate.isBefore(otherEnd) && thisEnd.isAfter(other.startDate);
  }

  // 检查指定日期是否在有效期内
  bool isValidOnDate(DateTime date) {
    if (!isEnabled) return false;
    
    if (date.isBefore(startDate)) return false;
    
    if (endDate != null && date.isAfter(endDate!)) return false;
    
    return true;
  }

  // 计算从开始到指定日期的零花钱总额
  double calculateTotalAmount(DateTime toDate) {
    if (!isValidOnDate(toDate)) return 0.0;
    
    final endDate = this.endDate ?? toDate;
    final actualEndDate = toDate.isBefore(endDate) ? toDate : endDate;
    
    final days = actualEndDate.difference(startDate).inDays + 1;
    return dailyAmount * days;
  }

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'dailyAmount': dailyAmount,
      'accumulateToNext': accumulateToNext,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isEnabled': isEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PocketMoneyConfig.fromJson(Map<String, dynamic> json) {
    return PocketMoneyConfig(
      id: json['id'],
      memberId: json['memberId'],
      dailyAmount: json['dailyAmount'].toDouble(),
      accumulateToNext: json['accumulateToNext'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isEnabled: json['isEnabled'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
} 