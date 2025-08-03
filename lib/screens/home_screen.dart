import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/account_provider.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';
import 'add_transaction_screen.dart';
import 'account_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
      context.read<AccountProvider>().loadAccounts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildTransactionTab(),
          _buildStatisticsTab(),
          _buildAccountTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: '记账',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: '账户',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildTransactionTab() {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        if (transactionProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final transactions = transactionProvider.transactions;
        final monthRange = Helpers.getMonthRange(_selectedDate);
        final monthTransactions = transactions.where((t) =>
            t.date.isAfter(monthRange['start']!.subtract(const Duration(days: 1)) &&
            t.date.isBefore(monthRange['end']!.add(const Duration(days: 1)))).toList();

        return Column(
          children: [
            _buildMonthSelector(),
            _buildSummaryCards(monthRange),
            Expanded(
              child: _buildTransactionList(monthTransactions),
            ),
          ],
        );
      },
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

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
              ),
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

  Widget _buildTransactionList(List<dynamic> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('暂无交易记录', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: transaction.type == AppConstants.income
                  ? Colors.green
                  : Colors.red,
              child: Text(
                Helpers.getCategoryIcon(transaction.category),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            title: Text(transaction.category),
            subtitle: Text(
              transaction.note ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${transaction.type == AppConstants.income ? '+' : '-'}${Helpers.formatAmount(transaction.amount)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: transaction.type == AppConstants.income
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Text(
                  Helpers.formatDate(transaction.date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    return const StatisticsScreen();
  }

  Widget _buildAccountTab() {
    return const AccountScreen();
  }
} 