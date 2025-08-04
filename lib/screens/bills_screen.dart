import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:intl/intl.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账单'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '月账单'),
            Tab(text: '年账单'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMonthlyBills(),
          _buildYearlyBills(),
        ],
      ),
    );
  }

  Widget _buildMonthlyBills() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final transactions = appProvider.transactions;
        final yearTransactions = transactions.where((t) => t.date.year == _selectedYear).toList();
        
        // 计算年度统计数据
        double yearIncome = 0;
        double yearExpense = 0;
        for (final transaction in yearTransactions) {
          if (transaction.type == 'income') {
            yearIncome += transaction.amount;
          } else {
            yearExpense += transaction.amount;
          }
        }
        final yearBalance = yearIncome - yearExpense;

        return Column(
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
                      });
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
            
            // 年度概览卡片
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
                    '$_selectedYear年概览',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOverviewItem(
                          '年收入',
                          '¥${NumberFormat('#,##0').format(yearIncome)}',
                          Colors.green,
                          Icons.trending_up,
                        ),
                      ),
                      Expanded(
                        child: _buildOverviewItem(
                          '年支出',
                          '¥${NumberFormat('#,##0').format(yearExpense)}',
                          Colors.red,
                          Icons.trending_down,
                        ),
                      ),
                      Expanded(
                        child: _buildOverviewItem(
                          '年结余',
                          '¥${NumberFormat('#,##0').format(yearBalance)}',
                          Theme.of(context).colorScheme.primary,
                          Icons.account_balance_wallet,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 月份列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  return _buildMonthItem(month, yearTransactions);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildYearlyBills() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final transactions = appProvider.transactions;
        
        // 按年份分组统计
        final yearStats = <int, Map<String, double>>{};
        for (final transaction in transactions) {
          final year = transaction.date.year;
          yearStats.putIfAbsent(year, () => {'income': 0, 'expense': 0});
          
          if (transaction.type == 'income') {
            yearStats[year]!['income'] = yearStats[year]!['income']! + transaction.amount;
          } else {
            yearStats[year]!['expense'] = yearStats[year]!['expense']! + transaction.amount;
          }
        }
        
        // 计算总统计数据
        double totalIncome = 0;
        double totalExpense = 0;
        for (final stats in yearStats.values) {
          totalIncome += stats['income']!;
          totalExpense += stats['expense']!;
        }
        final totalBalance = totalIncome - totalExpense;
        
        final sortedYears = yearStats.keys.toList()..sort((a, b) => b.compareTo(a));

        return Column(
          children: [
            // 概览卡片
            Container(
              margin: const EdgeInsets.all(16),
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
                  const Text(
                    '总览',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOverviewItem(
                          '总支出',
                          '¥${NumberFormat('#,##0').format(totalExpense)}',
                          Colors.red,
                          Icons.trending_down,
                        ),
                      ),
                      Expanded(
                        child: _buildOverviewItem(
                          '总收入',
                          '¥${NumberFormat('#,##0').format(totalIncome)}',
                          Colors.green,
                          Icons.trending_up,
                        ),
                      ),
                      Expanded(
                        child: _buildOverviewItem(
                          '总结余',
                          '¥${NumberFormat('#,##0').format(totalBalance)}',
                          Theme.of(context).colorScheme.primary,
                          Icons.account_balance_wallet,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 年份列表
            Expanded(
              child: sortedYears.isEmpty 
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: sortedYears.length,
                      itemBuilder: (context, index) {
                        final year = sortedYears[index];
                        final stats = yearStats[year]!;
                        return _buildYearItem(year, stats['income']!, stats['expense']!);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无账单数据',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '开始记账后可以查看账单统计',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String title, String amount, Color color, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          amount,
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

  Widget _buildMonthItem(int month, List<dynamic> yearTransactions) {
    final monthNames = [
      '一月', '二月', '三月', '四月', '五月', '六月',
      '七月', '八月', '九月', '十月', '十一月', '十二月'
    ];
    
    // 计算该月的收支
    final monthTransactions = yearTransactions.where((t) => t.date.month == month).toList();
    double income = 0;
    double expense = 0;
    for (final transaction in monthTransactions) {
      if (transaction.type == 'income') {
        income += transaction.amount;
      } else {
        expense += transaction.amount;
      }
    }
    final balance = income - expense;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // 月份
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                month.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 月份信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthNames[month - 1],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '收入: ¥${NumberFormat('#,##0').format(income)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '支出: ¥${NumberFormat('#,##0').format(expense)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 结余
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${NumberFormat('#,##0').format(balance)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: balance >= 0 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.red,
                ),
              ),
              Text(
                balance >= 0 ? '结余' : '超支',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYearItem(int year, double income, double expense) {
    final balance = income - expense;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // 年份
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                year.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // 年份信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$year年',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '收入: ¥${NumberFormat('#,##0').format(income)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '支出: ¥${NumberFormat('#,##0').format(expense)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 结余
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${NumberFormat('#,##0').format(balance)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: balance >= 0 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.red,
                ),
              ),
              Text(
                balance >= 0 ? '结余' : '超支',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
} 