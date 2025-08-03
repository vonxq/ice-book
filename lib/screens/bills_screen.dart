import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/widgets/transaction_list.dart';

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('账单'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: 实现筛选功能
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 账单统计
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Consumer<AppProvider>(
                builder: (context, appProvider, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          context,
                          title: '本月账单',
                          value: '${appProvider.transactions.length}笔',
                          icon: Icons.receipt_long,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          title: '总支出',
                          value: '¥${appProvider.monthlyExpense.toStringAsFixed(0)}',
                          icon: Icons.trending_down,
                        ),
                      ),
                      Expanded(
                        child: _buildStatItem(
                          context,
                          title: '总收入',
                          value: '¥${appProvider.monthlyIncome.toStringAsFixed(0)}',
                          icon: Icons.trending_up,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            
            // 交易列表
            const Expanded(
              child: TransactionList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 