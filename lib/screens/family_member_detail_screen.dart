import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/models/family_member.dart';
import 'package:ice_book/models/pocket_money_record.dart';

class FamilyMemberDetailScreen extends StatefulWidget {
  final FamilyMember member;

  const FamilyMemberDetailScreen({
    super.key,
    required this.member,
  });

  @override
  State<FamilyMemberDetailScreen> createState() => _FamilyMemberDetailScreenState();
}

class _FamilyMemberDetailScreenState extends State<FamilyMemberDetailScreen> {
  double _pocketMoneyBalance = 0.0;
  List<PocketMoneyRecord> _records = [];

  @override
  void initState() {
    super.initState();
    _loadPocketMoneyData();
  }

  void _loadPocketMoneyData() {
    // TODO: 从数据库加载零花钱余额和记录
    setState(() {
      _pocketMoneyBalance = 150.0; // 示例数据
      _records = [
        PocketMoneyRecord(
          id: '1',
          memberId: widget.member.id,
          amount: 30.0,
          type: 'daily',
          note: '日常零花钱',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        PocketMoneyRecord(
          id: '2',
          memberId: widget.member.id,
          amount: -15.0,
          type: 'expense',
          note: '午餐',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.member.name}的零花钱'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 成员信息和零花钱概览卡片
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // 成员头像
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    widget.member.name[0],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 成员信息和零花钱余额
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.member.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '零花钱余额',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '¥${_pocketMoneyBalance.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // 编辑按钮
                IconButton(
                  onPressed: () {
                    // TODO: 编辑成员信息
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ),
          
          // 快速操作按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddExpenseDialog(),
                    icon: const Icon(Icons.remove),
                    label: const Text('新增支出'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddRewardDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('发放奖励'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddPenaltyDialog(),
                    icon: const Icon(Icons.gavel),
                    label: const Text('扣除罚款'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 记录列表标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  '记录列表',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: 查看所有记录
                  },
                  child: const Text('查看全部'),
                ),
              ],
            ),
          ),
          
          // 记录列表
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return _buildRecordItem(record);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(PocketMoneyRecord record) {
    Color amountColor;
    IconData icon;
    String typeText;
    
    switch (record.type) {
      case 'daily':
        amountColor = Colors.green;
        icon = Icons.add_circle;
        typeText = '日常发放';
        break;
      case 'reward':
        amountColor = Colors.blue;
        icon = Icons.card_giftcard;
        typeText = '奖励';
        break;
      case 'expense':
        amountColor = Colors.red;
        icon = Icons.remove_circle;
        typeText = '支出';
        break;
      case 'penalty':
        amountColor = Colors.orange;
        icon = Icons.gavel;
        typeText = '罚款';
        break;
      default:
        amountColor = Colors.grey;
        icon = Icons.circle;
        typeText = '其他';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: amountColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.note,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      typeText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(record.date),
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
          Text(
            '${record.amount >= 0 ? '+' : ''}¥${record.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recordDate = DateTime(date.year, date.month, date.day);
    
    if (recordDate == today) {
      return '今天';
    } else if (recordDate == today.subtract(const Duration(days: 1))) {
      return '昨天';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddExpenseDialog(member: widget.member),
    ).then((_) => _loadPocketMoneyData());
  }

  void _showAddRewardDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddRewardDialog(member: widget.member),
    ).then((_) => _loadPocketMoneyData());
  }

  void _showAddPenaltyDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddPenaltyDialog(member: widget.member),
    ).then((_) => _loadPocketMoneyData());
  }
}

// 新增支出对话框
class _AddExpenseDialog extends StatefulWidget {
  final FamilyMember member;

  const _AddExpenseDialog({required this.member});

  @override
  State<_AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<_AddExpenseDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('为${widget.member.name}新增支出'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '支出金额',
              prefixText: '¥',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: '支出备注',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: 保存支出记录
            Navigator.of(context).pop();
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
}

// 发放奖励对话框
class _AddRewardDialog extends StatefulWidget {
  final FamilyMember member;

  const _AddRewardDialog({required this.member});

  @override
  State<_AddRewardDialog> createState() => _AddRewardDialogState();
}

class _AddRewardDialogState extends State<_AddRewardDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('为${widget.member.name}发放奖励'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '奖励金额',
              prefixText: '¥',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: '奖励原因',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: 保存奖励记录
            Navigator.of(context).pop();
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
}

// 扣除罚款对话框
class _AddPenaltyDialog extends StatefulWidget {
  final FamilyMember member;

  const _AddPenaltyDialog({required this.member});

  @override
  State<_AddPenaltyDialog> createState() => _AddPenaltyDialogState();
}

class _AddPenaltyDialogState extends State<_AddPenaltyDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('为${widget.member.name}扣除罚款'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '罚款金额',
              prefixText: '¥',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: '罚款原因',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: 保存罚款记录
            Navigator.of(context).pop();
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
} 