import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../providers/account_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  String _selectedType = AppConstants.expense;
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  String? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _selectedCategory = AppConstants.expenseCategories.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加记录'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTypeSelector(),
            const SizedBox(height: 16),
            _buildCategorySelector(),
            const SizedBox(height: 16),
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildAccountSelector(),
            const SizedBox(height: 16),
            _buildNoteField(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('类型', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    '支出',
                    AppConstants.expense,
                    Colors.red,
                    Icons.trending_down,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeButton(
                    '收入',
                    AppConstants.income,
                    Colors.green,
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String type, Color color, IconData icon) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = type == AppConstants.expense
              ? AppConstants.expenseCategories.first
              : AppConstants.incomeCategories.first;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = _selectedType == AppConstants.expense
        ? AppConstants.expenseCategories
        : AppConstants.incomeCategories;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('分类', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Helpers.getCategoryIcon(category),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('金额', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '请输入金额',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入金额';
                }
                if (!Helpers.isValidAmount(value)) {
                  return '请输入有效的金额';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('日期', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(Helpers.formatDate(_selectedDate)),
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                );
                if (date != null) {
                  setState(() {
                    _selectedDate = date;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSelector() {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, child) {
        final accounts = accountProvider.accounts;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('账户', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (accounts.isEmpty)
                  const Text('暂无账户，请在账户页面添加账户', style: TextStyle(color: Colors.grey))
                else
                  DropdownButtonFormField<String>(
                    value: _selectedAccount,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '选择账户（可选）',
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('不选择账户'),
                      ),
                      ...accounts.map((account) {
                        return DropdownMenuItem<String>(
                          value: account.name,
                          child: Row(
                            children: [
                              Text(Helpers.getAccountTypeIcon(account.type)),
                              const SizedBox(width: 8),
                              Text(account.name),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedAccount = value;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('备注', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: '添加备注（可选）',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        child: const Text('保存', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void _submitTransaction() {
    if (_formKey.currentState!.validate()) {
      final transaction = Transaction(
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        type: _selectedType,
        note: _noteController.text.isEmpty ? null : _noteController.text,
        date: _selectedDate,
        account: _selectedAccount,
      );

      context.read<TransactionProvider>().addTransaction(transaction);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('交易记录已保存')),
      );
      
      Navigator.pop(context);
    }
  }
} 