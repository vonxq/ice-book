import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnnualActivityScreen extends StatefulWidget {
  const AnnualActivityScreen({super.key});

  @override
  State<AnnualActivityScreen> createState() => _AnnualActivityScreenState();
}

class _AnnualActivityScreenState extends State<AnnualActivityScreen> {
  int _selectedYear = DateTime.now().year;
  bool _showIncome = false;
  bool _showMembers = false;

  // 示例数据 - 全年支出热力图数据
  final Map<String, double> _dailyExpenses = {};

  @override
  void initState() {
    super.initState();
    _generateSampleData();
  }

  void _generateSampleData() {
    final random = math.Random(42); // 固定种子，确保数据一致
    final startDate = DateTime(_selectedYear, 1, 1);
    final endDate = DateTime(_selectedYear, 12, 31);
    
    for (DateTime date = startDate; 
         date.isBefore(endDate.add(const Duration(days: 1))); 
         date = date.add(const Duration(days: 1))) {
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      // 生成示例数据：工作日支出较多，周末较少
      double amount = 0;
      if (date.weekday <= 5) { // 工作日
        amount = random.nextDouble() * 200 + 50; // 50-250
      } else { // 周末
        amount = random.nextDouble() * 150 + 30; // 30-180
      }
      
      // 某些特殊日期支出更多
      if (date.month == 12 && date.day <= 25) { // 圣诞节前
        amount += random.nextDouble() * 100;
      }
      
      _dailyExpenses[key] = amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('年度活跃度'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showSettingsDialog(),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // 年份选择器
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedYear--;
                      _generateSampleData();
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showYearPicker(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$_selectedYear年',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedYear++;
                      _generateSampleData();
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          
          // 统计信息
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$_selectedYear年支出统计',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        '总支出',
                        '¥${_getTotalExpense().toStringAsFixed(0)}',
                        Colors.red,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '平均日支出',
                        '¥${_getAverageDailyExpense().toStringAsFixed(0)}',
                        Colors.orange,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '最高日支出',
                        '¥${_getMaxDailyExpense().toStringAsFixed(0)}',
                        Colors.purple,
                      ),
                    ),
                    Expanded(
                      child: _buildStatItem(
                        '有支出天数',
                        '${_getExpenseDays()}天',
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 热力图
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '支出热力图',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _buildHeatmap(),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmap() {
    return Column(
      children: [
        // 月份标签
        Row(
          children: [
            const SizedBox(width: 20), // 对齐网格
            ...List.generate(12, (index) {
              final month = index + 1;
              return Expanded(
                child: Center(
                  child: Text(
                    '$month月',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 8),
        
        // 热力图网格
        Expanded(
          child: Row(
            children: [
              // 星期标签
              Column(
                children: [
                  const SizedBox(height: 8),
                  ...List.generate(7, (index) {
                    final weekdays = ['日', '一', '二', '三', '四', '五', '六'];
                    return Expanded(
                      child: Center(
                        child: Text(
                          weekdays[index],
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(width: 8),
              
              // 热力图
              Expanded(
                child: _buildHeatmapGrid(),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // 图例
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '支出金额: ',
              style: TextStyle(fontSize: 12),
            ),
            ...List.generate(5, (index) {
              final colors = [
                Colors.grey.shade200,
                Colors.green.shade200,
                Colors.green.shade400,
                Colors.orange.shade400,
                Colors.red.shade400,
              ];
              final labels = ['0', '50', '200', '500', '500+'];
              
              return Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors[index],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    labels[index],
                    style: const TextStyle(fontSize: 10),
                  ),
                  if (index < 4) const SizedBox(width: 8),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildHeatmapGrid() {
    final weeks = _getWeeksInYear();
    
    return Column(
      children: List.generate(weeks.length, (weekIndex) {
        final week = weeks[weekIndex];
        return Expanded(
          child: Row(
            children: List.generate(7, (dayIndex) {
              final date = week[dayIndex];
              if (date == null) {
                return const Expanded(child: SizedBox());
              }
              
              final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
              final amount = _dailyExpenses[key] ?? 0.0;
              final color = _getColorForAmount(amount);
              
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: GestureDetector(
                    onTap: () => _showDayDetail(date, amount),
                    child: Tooltip(
                      message: '${date.month}月${date.day}日: ¥${amount.toStringAsFixed(0)}',
                      child: const SizedBox(),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  List<List<DateTime?>> _getWeeksInYear() {
    final weeks = <List<DateTime?>>[];
    final startDate = DateTime(_selectedYear, 1, 1);
    final endDate = DateTime(_selectedYear, 12, 31);
    
    // 找到第一周的开始（周日）
    final firstWeekStart = startDate.subtract(Duration(days: startDate.weekday % 7));
    
    DateTime currentDate = firstWeekStart;
    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      final week = <DateTime?>[];
      for (int i = 0; i < 7; i++) {
        final date = currentDate.add(Duration(days: i));
        if (date.year == _selectedYear) {
          week.add(date);
        } else {
          week.add(null);
        }
      }
      weeks.add(week);
      currentDate = currentDate.add(const Duration(days: 7));
    }
    
    return weeks;
  }

  Color _getColorForAmount(double amount) {
    if (amount == 0) return Colors.grey.shade200;
    if (amount <= 50) return Colors.green.shade200;
    if (amount <= 200) return Colors.green.shade400;
    if (amount <= 500) return Colors.orange.shade400;
    return Colors.red.shade400;
  }

  double _getTotalExpense() {
    return _dailyExpenses.values.fold(0.0, (sum, amount) => sum + amount);
  }

  double _getAverageDailyExpense() {
    final total = _getTotalExpense();
    final days = _dailyExpenses.length;
    return days > 0 ? total / days : 0;
  }

  double _getMaxDailyExpense() {
    return _dailyExpenses.values.fold(0.0, (max, amount) => math.max(max, amount));
  }

  int _getExpenseDays() {
    return _dailyExpenses.values.where((amount) => amount > 0).length;
  }

  void _showDayDetail(DateTime date, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${date.month}月${date.day}日'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('支出金额: ¥${amount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('日期: ${date.year}年${date.month}月${date.day}日'),
            const SizedBox(height: 8),
            Text('星期: ${_getWeekdayText(date.weekday)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  String _getWeekdayText(int weekday) {
    const weekdays = ['日', '一', '二', '三', '四', '五', '六'];
    return '星期${weekdays[weekday % 7]}';
  }

  void _showYearPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择年份'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearPicker(
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
            selectedDate: DateTime(_selectedYear),
            onChanged: (dateTime) {
              setState(() {
                _selectedYear = dateTime.year;
                _generateSampleData();
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('显示收入'),
              value: _showIncome,
              onChanged: (value) {
                setState(() {
                  _showIncome = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('显示成员'),
              value: _showMembers,
              onChanged: (value) {
                setState(() {
                  _showMembers = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
} 