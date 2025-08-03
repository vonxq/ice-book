import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  
  String _selectedType = AppConstants.cash;
  String _selectedColor = AppConstants.colors.first;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加账户'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAccountTypeSelector(),
            const SizedBox(height: 16),
            _buildNameField(),
            const SizedBox(height: 16),
            _buildBalanceField(),
            const SizedBox(height: 16),
            if (_selectedType == AppConstants.bank) ...[
              _buildBankNameField(),
              const SizedBox(height: 16),
              _buildAccountNumberField(),
              const SizedBox(height: 16),
            ],
            _buildColorSelector(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('账户类型', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTypeButton('现金', AppConstants.cash, '💵'),
                _buildTypeButton('银行账户', AppConstants.bank, '🏦'),
                _buildTypeButton('信用卡', AppConstants.credit, '💳'),
                _buildTypeButton('投资账户', AppConstants.investment, '📊'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, String type, String icon) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type;
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
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('账户名称', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '请输入账户名称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入账户名称';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('初始余额', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '请输入初始余额',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入初始余额';
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

  Widget _buildBankNameField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('银行名称', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bankNameController,
              decoration: const InputDecoration(
                hintText: '请输入银行名称（可选）',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountNumberField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('账号', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _accountNumberController,
              decoration: const InputDecoration(
                hintText: '请输入账号（可选）',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('账户颜色', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.colors.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(Helpers.hexToColor(color)),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
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

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        child: const Text('保存', style: TextStyle(fontSize: 18)),
      ),
    );
  }

  void _submitAccount() {
    if (_formKey.currentState!.validate()) {
      final account = Account(
        name: _nameController.text,
        type: _selectedType,
        balance: double.parse(_balanceController.text),
        bankName: _bankNameController.text.isEmpty ? null : _bankNameController.text,
        accountNumber: _accountNumberController.text.isEmpty ? null : _accountNumberController.text,
        color: _selectedColor,
      );

      context.read<AccountProvider>().addAccount(account);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('账户已保存')),
      );
      
      Navigator.pop(context);
    }
  }
} 