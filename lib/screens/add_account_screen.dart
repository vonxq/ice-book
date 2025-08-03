import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/models/account.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _selectedType = 'bank';
  String _selectedIcon = '🏦';
  String _selectedColor = '#3B82F6';

  final List<Map<String, String>> _accountTypes = [
    {'value': 'bank', 'label': '银行账户', 'icon': '🏦'},
    {'value': 'cash', 'label': '现金', 'icon': '💰'},
    {'value': 'credit', 'label': '信用卡', 'icon': '💳'},
    {'value': 'investment', 'label': '投资账户', 'icon': '📈'},
  ];

  final List<Map<String, String>> _colors = [
    {'value': '#3B82F6', 'label': '蓝色'},
    {'value': '#10B981', 'label': '绿色'},
    {'value': '#F59E0B', 'label': '橙色'},
    {'value': '#EF4444', 'label': '红色'},
    {'value': '#8B5CF6', 'label': '紫色'},
    {'value': '#06B6D4', 'label': '青色'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('添加账户'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveAccount,
            child: const Text('保存'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 账户类型选择
                const Text(
                  '账户类型',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: _accountTypes.length,
                  itemBuilder: (context, index) {
                    final type = _accountTypes[index];
                    final isSelected = _selectedType == type['value'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = type['value']!;
                          _selectedIcon = type['icon']!;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected 
                              ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            Text(
                              type['icon']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              type['label']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected 
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                
                // 账户名称
                const Text(
                  '账户名称',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '账户名称',
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
                const SizedBox(height: 24),
                
                // 账户余额
                const Text(
                  '账户余额',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _balanceController,
                  decoration: const InputDecoration(
                    labelText: '账户余额',
                    hintText: '请输入账户余额',
                    border: OutlineInputBorder(),
                    prefixText: '¥',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入账户余额';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // 颜色选择
                const Text(
                  '账户颜色',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = _selectedColor == color['value'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color['value']!;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(int.parse(color['value']!.replaceAll('#', '0xFF'))),
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected 
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 20)
                            : null,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      final account = Account(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user_001', // TODO: 使用当前用户ID
        name: _nameController.text,
        type: _selectedType,
        bankName: _selectedType == 'bank' ? '银行' : '',
        balance: double.parse(_balanceController.text),
        icon: _selectedIcon,
        color: _selectedColor,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      context.read<AppProvider>().addAccount(account);
      Navigator.of(context).pop();
    }
  }
} 