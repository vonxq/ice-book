import 'package:flutter/material.dart';
import 'package:ice_book/widgets/calculator_input.dart';
import 'package:ice_book/widgets/category_grid.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _transactionType = 'expense'; // income 或 expense
  String? _selectedCategoryId;
  String _note = '';
  DateTime _selectedDate = DateTime.now();
  double _amount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('记账'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _canSave() ? _saveTransaction : null,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 收入/支出切换
          _buildTypeToggle(),
          
          // 分类选择
          CategoryGrid(
            type: _transactionType,
            selectedCategoryId: _selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                _selectedCategoryId = categoryId;
              });
            },
          ),
          
          // 备注和日期
          _buildNoteAndDate(),
          
          // 计算器输入
          Expanded(
            child: CalculatorInput(
              onAmountChanged: (amount) {
                setState(() {
                  _amount = amount;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _transactionType = 'income';
                  _selectedCategoryId = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _transactionType == 'income' 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '收入',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _transactionType == 'income'
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _transactionType = 'expense';
                  _selectedCategoryId = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _transactionType == 'expense' 
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '支出',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _transactionType == 'expense'
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteAndDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 备注输入
          TextField(
            decoration: const InputDecoration(
              labelText: '备注',
              hintText: '请输入备注信息',
            ),
            onChanged: (value) {
              setState(() {
                _note = value;
              });
            },
          ),
          const SizedBox(height: 16),
          // 日期选择
          Row(
            children: [
              const Text('日期: '),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _canSave() {
    return _selectedCategoryId != null && _amount > 0;
  }

  void _saveTransaction() {
    if (!_canSave()) return;

    // TODO: 保存交易记录到数据库
    // 这里需要实现实际的保存逻辑
    
    Navigator.of(context).pop();
  }
} 