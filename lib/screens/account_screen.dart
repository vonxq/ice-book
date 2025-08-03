import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';
import 'add_account_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('账户管理'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AccountProvider>(
        builder: (context, accountProvider, child) {
          if (accountProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final accounts = accountProvider.accounts;
          final totalAssets = accountProvider.totalAssets;

          return Column(
            children: [
              _buildTotalAssetsCard(totalAssets),
              Expanded(
                child: _buildAccountList(accounts),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAccountScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalAssetsCard(double totalAssets) {
    return Card(
      margin: const EdgeInsets.all(16),
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '总资产',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Helpers.formatAmount(totalAssets),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountList(List<Account> accounts) {
    if (accounts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无账户', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 8),
            Text('点击右下角按钮添加账户', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getAccountColor(account.type),
              child: Text(
                Helpers.getAccountTypeIcon(account.type),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            title: Text(account.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getAccountTypeName(account.type)),
                if (account.bankName != null) Text('银行: ${account.bankName}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Helpers.formatAmount(account.balance),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      onPressed: () => _editAccount(context, account),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 16),
                      onPressed: () => _deleteAccount(context, account),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getAccountColor(String type) {
    switch (type) {
      case AppConstants.cash:
        return Colors.green;
      case AppConstants.bank:
        return Colors.blue;
      case AppConstants.credit:
        return Colors.orange;
      case AppConstants.investment:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getAccountTypeName(String type) {
    switch (type) {
      case AppConstants.cash:
        return '现金';
      case AppConstants.bank:
        return '银行账户';
      case AppConstants.credit:
        return '信用卡';
      case AppConstants.investment:
        return '投资账户';
      default:
        return '其他';
    }
  }

  void _editAccount(BuildContext context, Account account) {
    // TODO: 实现编辑账户功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('编辑功能开发中...')),
    );
  }

  void _deleteAccount(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除账户 "${account.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              context.read<AccountProvider>().deleteAccount(account.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('账户已删除')),
              );
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 