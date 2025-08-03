import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('图表分析'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 统计概览
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bar_chart,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '本月统计',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                title: '收入',
                                amount: '¥${appProvider.monthlyIncome.toStringAsFixed(0)}',
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                title: '支出',
                                amount: '¥${appProvider.monthlyExpense.toStringAsFixed(0)}',
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                title: '结余',
                                amount: '¥${appProvider.monthlyBalance.toStringAsFixed(0)}',
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // 支出分类
              const Text(
                '支出分类',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    final transactions = appProvider.transactions;
                    final expenseTransactions = transactions.where((t) => t.type == 'expense').toList();
                    
                    if (expenseTransactions.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    
                    // 按分类统计支出
                    final categoryStats = <String, double>{};
                    for (final transaction in expenseTransactions) {
                      categoryStats[transaction.categoryId] = (categoryStats[transaction.categoryId] ?? 0) + transaction.amount;
                    }
                    
                    final totalExpense = categoryStats.values.fold(0.0, (sum, amount) => sum + amount);
                    final sortedCategories = categoryStats.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));
                    
                    return ListView.builder(
                      itemCount: sortedCategories.length,
                      itemBuilder: (context, index) {
                        final entry = sortedCategories[index];
                        final categoryId = entry.key;
                        final amount = entry.value;
                        final percentage = totalExpense > 0 ? amount / totalExpense : 0.0;
                        
                        return _buildCategoryItem(
                          context,
                          categoryId: categoryId,
                          amount: amount,
                          percentage: percentage,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无支出数据',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '开始记账后可以查看支出分类统计',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required String categoryId,
    required double amount,
    required double percentage,
  }) {
    final categoryInfo = _getCategoryInfo(categoryId);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoryInfo['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                categoryInfo['icon'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryInfo['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¥${amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: categoryInfo['color'],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: categoryInfo['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: categoryInfo['color'],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getCategoryInfo(String categoryId) {
    switch (categoryId) {
      case 'expense_food':
        return {'name': '餐饮', 'icon': '🍽️', 'color': Colors.orange};
      case 'expense_transport':
        return {'name': '交通', 'icon': '🚗', 'color': Colors.blue};
      case 'expense_shopping':
        return {'name': '购物', 'icon': '🛒', 'color': Colors.green};
      case 'expense_entertainment':
        return {'name': '娱乐', 'icon': '🎮', 'color': Colors.purple};
      case 'expense_medical':
        return {'name': '医疗', 'icon': '🏥', 'color': Colors.red};
      case 'expense_education':
        return {'name': '教育', 'icon': '📚', 'color': Colors.cyan};
      case 'expense_housing':
        return {'name': '住房', 'icon': '🏠', 'color': Colors.orange};
      default:
        return {'name': '其他', 'icon': '📦', 'color': Colors.grey};
    }
  }
} 