import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';

class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedCategory = 'expense_food';
  String _selectedPeriod = 'monthly';

  final List<Map<String, String>> _categories = [
    {'value': 'expense_food', 'label': '餐饮', 'icon': '🍽️'},
    {'value': 'expense_transport', 'label': '交通', 'icon': '🚗'},
    {'value': 'expense_shopping', 'label': '购物', 'icon': '🛒'},
    {'value': 'expense_entertainment', 'label': '娱乐', 'icon': '🎮'},
    {'value': 'expense_medical', 'label': '医疗', 'icon': '🏥'},
    {'value': 'expense_education', 'label': '教育', 'icon': '📚'},
    {'value': 'expense_housing', 'label': '住房', 'icon': '🏠'},
  ];

  final List<Map<String, String>> _periods = [
    {'value': 'monthly', 'label': '月度预算'},
    {'value': 'weekly', 'label': '周度预算'},
    {'value': 'yearly', 'label': '年度预算'},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('添加预算'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveBudget,
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
                // 分类选择
                const Text(
                  '选择分类',
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
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category['value'];
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category['value']!;
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
                              category['icon']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category['label']!,
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
                
                // 预算金额
                const Text(
                  '预算金额',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: '预算金额',
                    hintText: '请输入预算金额',
                    border: OutlineInputBorder(),
                    prefixText: '¥',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入预算金额';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的数字';
                    }
                    if (double.parse(value) <= 0) {
                      return '预算金额必须大于0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // 预算周期
                const Text(
                  '预算周期',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Column(
                  children: _periods.map((period) {
                    final isSelected = _selectedPeriod == period['value'];
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: RadioListTile<String>(
                        title: Text(period['label']!),
                        value: period['value']!,
                        groupValue: _selectedPeriod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriod = value!;
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      // TODO: 实现预算保存逻辑
      // 这里需要创建Budget模型和相关的Provider方法
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('预算设置'),
          content: Text('为${_getCategoryName(_selectedCategory)}设置${_getPeriodName(_selectedPeriod)}预算¥${_amountController.text}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    }
  }

  String _getCategoryName(String categoryId) {
    final category = _categories.firstWhere((c) => c['value'] == categoryId);
    return category['label']!;
  }

  String _getPeriodName(String periodId) {
    final period = _periods.firstWhere((p) => p['value'] == periodId);
    return period['label']!;
  }
} 