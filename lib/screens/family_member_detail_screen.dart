import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/models/family_member.dart';
import 'package:ice_book/models/pocket_money_config.dart';
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.member.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditMemberDialog(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 成员信息卡片
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // 头像和姓名
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              widget.member.avatar,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.member.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getRoleText(widget.member.role),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // 零花钱概览
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '零花钱余额',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '¥0.00', // TODO: 从零花钱记录计算
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                '今日收入',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '¥0.00', // TODO: 从零花钱配置计算
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // 零花钱配置
              Row(
                children: [
                  const Text(
                    '零花钱配置',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      _showAddConfigDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('添加配置'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 配置列表
              Expanded(
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    // TODO: 从Provider获取零花钱配置列表
                    final configs = <PocketMoneyConfig>[];
                    
                    if (configs.isEmpty) {
                      return _buildEmptyConfigState(context);
                    }
                    
                    return ListView.builder(
                      itemCount: configs.length,
                      itemBuilder: (context, index) {
                        final config = configs[index];
                        return _buildConfigCard(context, config);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyConfigState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无零花钱配置',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击"添加配置"设置零花钱',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigCard(BuildContext context, PocketMoneyConfig config) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '日零花钱: ¥${NumberFormat('#,##0.00').format(config.dailyAmount)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '开始时间: ${DateFormat('yyyy-MM-dd').format(config.startDate)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    if (config.endDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '结束时间: ${DateFormat('yyyy-MM-dd').format(config.endDate!)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        '结束时间: 永久有效',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  Switch(
                    value: config.isEnabled,
                    onChanged: (value) {
                      // TODO: 更新配置状态
                    },
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showEditConfigDialog(context, config);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                config.accumulateToNext ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: config.accumulateToNext ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                config.accumulateToNext ? '累计到下期' : '不累计',
                style: TextStyle(
                  fontSize: 12,
                  color: config.accumulateToNext ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRoleText(String role) {
    switch (role) {
      case 'parent':
        return '家长';
      case 'child':
        return '孩子';
      default:
        return '成员';
    }
  }

  void _showEditMemberDialog(BuildContext context) {
    final nameController = TextEditingController(text: widget.member.name);
    String selectedRole = widget.member.role;
    String selectedAvatar = widget.member.avatar;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑家庭成员'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '姓名',
                    hintText: '请输入家庭成员姓名',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('角色: '),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'parent', child: Text('家长')),
                          DropdownMenuItem(value: 'child', child: Text('孩子')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('头像: '),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedAvatar,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: '👨', child: Text('👨')),
                          DropdownMenuItem(value: '👩', child: Text('👩')),
                          DropdownMenuItem(value: '👧', child: Text('👧')),
                          DropdownMenuItem(value: '👦', child: Text('👦')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedAvatar = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final updatedMember = widget.member.copyWith(
                  name: nameController.text,
                  role: selectedRole,
                  avatar: selectedAvatar,
                  updatedAt: DateTime.now(),
                );
                
                context.read<AppProvider>().updateFamilyMember(updatedMember);
                Navigator.of(context).pop();
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showAddConfigDialog(BuildContext context) {
    final dailyAmountController = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime? endDate;
    bool accumulateToNext = true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加零花钱配置'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: dailyAmountController,
                  decoration: const InputDecoration(
                    labelText: '日零花钱金额',
                    hintText: '请输入每日零花钱金额',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('开始时间: '),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              startDate = date;
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
                            DateFormat('yyyy-MM-dd').format(startDate),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('结束时间: '),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: startDate,
                            lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
                          );
                          if (date != null) {
                            setState(() {
                              endDate = date;
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
                            endDate != null 
                                ? DateFormat('yyyy-MM-dd').format(endDate!)
                                : '永久有效',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: accumulateToNext,
                      onChanged: (value) {
                        setState(() {
                          accumulateToNext = value ?? true;
                        });
                      },
                    ),
                    const Text('累计到下期'),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (dailyAmountController.text.isNotEmpty) {
                final dailyAmount = double.tryParse(dailyAmountController.text);
                if (dailyAmount != null && dailyAmount > 0) {
                  final newConfig = PocketMoneyConfig(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    memberId: widget.member.id,
                    dailyAmount: dailyAmount,
                    accumulateToNext: accumulateToNext,
                    startDate: startDate,
                    endDate: endDate,
                    isEnabled: true,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  
                  // TODO: 保存零花钱配置
                  // context.read<AppProvider>().addPocketMoneyConfig(newConfig);
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showEditConfigDialog(BuildContext context, PocketMoneyConfig config) {
    // TODO: 实现编辑配置对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑零花钱配置'),
        content: const Text('编辑功能待实现'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
} 