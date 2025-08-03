import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final monthRange = Helpers.getMonthRange(_selectedDate);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildMonthSelector(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSummaryCards(monthRange),
                const SizedBox(height: 16),
                _buildPieChart(monthRange),
                const SizedBox(height: 16),
                _buildCategoryList(monthRange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            '${_selectedDate.year}年${_selectedDate.month}月',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, DateTime> monthRange) {
    return FutureBuilder<double>(
      future: context.read<TransactionProvider>().getTotalIncome(
        monthRange['start']!,
        monthRange['end']!,
      ),
      builder: (context, incomeSnapshot) {
        return FutureBuilder<double>(
          future: context.read<TransactionProvider>().getTotalExpense(
            monthRange['start']!,
            monthRange['end']!,
          ),
          builder: (context, expenseSnapshot) {
            final income = incomeSnapshot.data ?? 0.0;
            final expense = expenseSnapshot.data ?? 0.0;
            final balance = income - expense;

            return Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    '收入',
                    income,
                    Colors.green,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    '支出',
                    expense,
                    Colors.red,
                    Icons.trending_down,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    '结余',
                    balance,
                    balance >= 0 ? Colors.blue : Colors.orange,
                    Icons.account_balance_wallet,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              Helpers.formatAmount(amount),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, DateTime> monthRange) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: context.read<TransactionProvider>().getCategoryStats(
        monthRange['start']!,
        monthRange['end']!,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text('暂无数据', style: TextStyle(color: Colors.grey)),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final expenseData = data.where((item) => item['type'] == AppConstants.expense).toList();
        final incomeData = data.where((item) => item['type'] == AppConstants.income).toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('支出分类', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (expenseData.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: expenseData.map((item) {
                          final amount = (item['total'] as num).toDouble();
                          final category = item['category'] as String;
                          final percentage = amount / expenseData.fold(0.0, (sum, item) => sum + (item['total'] as num));
                          
                          return PieChartSectionData(
                            value: amount,
                            title: '${(percentage * 100).toStringAsFixed(1)}%',
                            color: _getCategoryColor(category),
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Text('暂无支出数据', style: TextStyle(color: Colors.grey)),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryList(Map<String, DateTime> monthRange) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: context.read<TransactionProvider>().getCategoryStats(
        monthRange['start']!,
        monthRange['end']!,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('暂无分类数据', style: TextStyle(color: Colors.grey)),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final expenseData = data.where((item) => item['type'] == AppConstants.expense).toList();
        final incomeData = data.where((item) => item['type'] == AppConstants.income).toList();

        return Column(
          children: [
            if (expenseData.isNotEmpty) ...[
              _buildCategorySection('支出分类', expenseData, Colors.red),
              const SizedBox(height: 16),
            ],
            if (incomeData.isNotEmpty) ...[
              _buildCategorySection('收入分类', incomeData, Colors.green),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCategorySection(String title, List<Map<String, dynamic>> data, Color color) {
    final total = data.fold(0.0, (sum, item) => sum + (item['total'] as num));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            ...data.map((item) {
              final amount = (item['total'] as num).toDouble();
              final category = item['category'] as String;
              final percentage = amount / total;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(Helpers.getCategoryIcon(category)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(category),
                    ),
                    Text(
                      Helpers.formatAmount(amount),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(percentage * 100).toStringAsFixed(1)}%',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    
    final index = category.hashCode % colors.length;
    return colors[index];
  }
} 