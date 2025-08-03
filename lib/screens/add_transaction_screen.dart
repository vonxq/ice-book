import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/widgets/calculator_input.dart';
import 'package:ice_book/widgets/category_grid.dart';
import 'package:ice_book/models/transaction.dart';
import 'package:ice_book/models/family_member.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _transactionType = 'expense'; // income 或 expense
  String? _selectedCategoryId;
  String? _selectedFamilyMemberId;
  String _note = '';
  DateTime _selectedDateTime = DateTime.now();
  double _amount = 0.0;
  bool _showDetails = false; // 控制是否显示详细信息

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
            child: Text(
              '保存',
              style: TextStyle(
                color: _canSave() 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
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
                  if (categoryId != null) {
                    _showDetails = true;
                  }
                });
              },
            ),
            
            // 详细信息（只有在选择了分类后才显示）
            if (_showDetails) ...[
              // 家庭成员选择
              _buildFamilyMemberSelection(),
              
              // 备注和日期时间
              _buildNoteAndDateTime(),
              
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
            ] else ...[
              // 提示信息
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '请先选择分类',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '选择分类后可以输入详细信息',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyMemberSelection() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final familyMembers = appProvider.familyMembers;
        
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '选择家庭成员',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              if (familyMembers.isEmpty)
                _buildAddFamilyMemberButton()
              else
                _buildFamilyMemberGrid(familyMembers),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddFamilyMemberButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            '添加家庭成员',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberGrid(List<FamilyMember> familyMembers) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: familyMembers.length,
      itemBuilder: (context, index) {
        final member = familyMembers[index];
        final isSelected = _selectedFamilyMemberId == member.id;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedFamilyMemberId = member.id;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  member.avatar,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
                  _showDetails = false;
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
                  _showDetails = false;
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

  Widget _buildNoteAndDateTime() {
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
          // 日期时间选择
          Row(
            children: [
              const Text('日期时间: '),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    // 先选择日期
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDateTime,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      // 再选择时间
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                      );
                      if (time != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_selectedDateTime.year}-${_selectedDateTime.month.toString().padLeft(2, '0')}-${_selectedDateTime.day.toString().padLeft(2, '0')} ${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                    ),
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
    final canSave = _selectedCategoryId != null && _amount > 0;
    print('保存按钮状态: 分类ID=$_selectedCategoryId, 金额=$_amount, 可保存=$canSave');
    return canSave;
  }

  void _saveTransaction() {
    print('尝试保存交易: 分类ID=$_selectedCategoryId, 金额=$_amount, 备注=$_note, 时间=$_selectedDateTime');
    
    if (!_canSave()) {
      print('保存失败: 条件不满足');
      return;
    }

    // 创建新的交易记录
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user_001', // 这里应该使用当前用户ID
      accountId: 'account_001', // 这里应该使用默认账户ID
      categoryId: _selectedCategoryId!,
      amount: _amount,
      type: _transactionType,
      note: _note.isEmpty ? '无备注' : _note,
      date: _selectedDateTime,
      budgetId: null,
      createdAt: DateTime.now(),
    );

    // 保存到Provider
    context.read<AppProvider>().addTransaction(transaction);
    
    print('保存成功，返回上一页');
    Navigator.of(context).pop();
  }
} 