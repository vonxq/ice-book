import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/models/transaction.dart';
import 'package:ice_book/utils/theme.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final transactions = appProvider.transactions;
        
        if (transactions.isEmpty) {
          return _buildEmptyState(context);
        }

        // 按天分组交易记录
        final groupedTransactions = _groupTransactionsByDate(transactions);
        
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: groupedTransactions.length,
          itemBuilder: (context, index) {
            final entry = groupedTransactions.entries.elementAt(index);
            final date = entry.key;
            final dayTransactions = entry.value;
            
            return _buildDayGroup(context, date, dayTransactions);
          },
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
            '暂无交易记录',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角按钮开始记账',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final grouped = <DateTime, List<Transaction>>{};
    
    for (final transaction in transactions) {
      final date = DateTime(transaction.date.year, transaction.date.month, transaction.date.day);
      grouped.putIfAbsent(date, () => []).add(transaction);
    }
    
    // 按日期排序
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedMap = <DateTime, List<Transaction>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = grouped[key]!;
    }
    
    return sortedMap;
  }

  Widget _buildDayGroup(BuildContext context, DateTime date, List<Transaction> transactions) {
    final themeMode = Theme.of(context).brightness == Brightness.dark 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    // 计算当天收支总额
    double dayIncome = 0;
    double dayExpense = 0;
    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        dayIncome += transaction.amount;
      } else {
        dayExpense += transaction.amount;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日期标题
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 8),
          child: Row(
            children: [
              Text(
                DateFormat('M月d日').format(date),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${dayIncome > 0 ? '收入' : '支出'}: ¥${NumberFormat('#,##0').format(dayIncome > 0 ? dayIncome : dayExpense)})',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        // 交易记录列表
        ...transactions.map((transaction) => _buildTransactionItem(context, transaction, themeMode)),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction, ThemeMode themeMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 分类图标
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCategoryColor(transaction.categoryId).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _getCategoryIcon(transaction.categoryId),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 交易信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '👨‍👩‍👧‍👦 全家',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('HH:mm').format(transaction.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 金额
          Text(
            '${transaction.type == 'income' ? '+' : '-'}¥${NumberFormat('#,##0').format(transaction.amount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaction.type == 'income' 
                  ? AppTheme.getIncomeColor(themeMode)
                  : AppTheme.getExpenseColor(themeMode),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(String categoryId) {
    // 这里应该从分类数据中获取图标，暂时使用默认图标
    switch (categoryId) {
      case 'expense_food':
        return '🍽️';
      case 'expense_transport':
        return '🚗';
      case 'expense_shopping':
        return '🛒';
      case 'expense_entertainment':
        return '🎮';
      case 'expense_medical':
        return '🏥';
      case 'expense_education':
        return '📚';
      case 'expense_housing':
        return '🏠';
      case 'income_salary':
        return '💰';
      case 'income_bonus':
        return '🎁';
      case 'income_investment':
        return '📈';
      default:
        return '📦';
    }
  }

  Color _getCategoryColor(String categoryId) {
    // 这里应该从分类数据中获取颜色，暂时使用默认颜色
    switch (categoryId) {
      case 'expense_food':
        return const Color(0xFFF59E0B);
      case 'expense_transport':
        return const Color(0xFF3B82F6);
      case 'expense_shopping':
        return const Color(0xFF10B981);
      case 'expense_entertainment':
        return const Color(0xFF8B5CF6);
      case 'expense_medical':
        return const Color(0xFFEF4444);
      case 'expense_education':
        return const Color(0xFF06B6D4);
      case 'expense_housing':
        return const Color(0xFFF97316);
      case 'income_salary':
        return const Color(0xFF10B981);
      case 'income_bonus':
        return const Color(0xFFF59E0B);
      case 'income_investment':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }
} 