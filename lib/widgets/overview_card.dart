import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/utils/theme.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final themeMode = Theme.of(context).brightness == Brightness.dark 
            ? ThemeMode.dark 
            : ThemeMode.light;
        
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
              // 年月显示
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('yyyy年').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        DateFormat('M月').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  // 收支统计
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '收入: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '¥${NumberFormat('#,##0').format(appProvider.monthlyIncome)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getIncomeColor(themeMode),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '支出: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '¥${NumberFormat('#,##0').format(appProvider.monthlyExpense)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.getExpenseColor(themeMode),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '结余: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            '¥${NumberFormat('#,##0').format(appProvider.monthlyBalance)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appProvider.monthlyBalance >= 0 
                                  ? AppTheme.getIncomeColor(themeMode)
                                  : AppTheme.getExpenseColor(themeMode),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // 快速统计标签
              Row(
                children: [
                  Expanded(
                    child: _buildStatTab(
                      context,
                      icon: Icons.trending_up,
                      label: '收入',
                      value: '¥${NumberFormat('#,##0').format(appProvider.monthlyIncome)}',
                      color: AppTheme.getIncomeColor(themeMode),
                      onTap: () => _showIncomeDetails(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatTab(
                      context,
                      icon: Icons.trending_down,
                      label: '支出',
                      value: '¥${NumberFormat('#,##0').format(appProvider.monthlyExpense)}',
                      color: AppTheme.getExpenseColor(themeMode),
                      onTap: () => _showExpenseDetails(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatTab(
                      context,
                      icon: Icons.account_balance_wallet,
                      label: '结余',
                      value: '¥${NumberFormat('#,##0').format(appProvider.monthlyBalance)}',
                      color: appProvider.monthlyBalance >= 0 
                          ? AppTheme.getIncomeColor(themeMode)
                          : AppTheme.getExpenseColor(themeMode),
                      onTap: () => _showBalanceDetails(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatTab(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showIncomeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('收入详情'),
        content: const Text('这里显示详细的收入信息，包括分类统计等。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showExpenseDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('支出详情'),
        content: const Text('这里显示详细的支出信息，包括分类统计等。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showBalanceDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('结余详情'),
        content: const Text('这里显示详细的结余信息，包括收支对比等。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
} 