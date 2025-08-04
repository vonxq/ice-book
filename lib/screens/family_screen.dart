import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/models/family_member.dart';
import 'package:ice_book/models/pocket_money_config.dart';
import 'package:ice_book/screens/family_member_detail_screen.dart';
import 'package:intl/intl.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('我的小家'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddMemberDialog(context);
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
              // 零花钱概览卡片
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    final familyMembers = appProvider.familyMembers;
                    
                    // 计算总零花钱余额和每日收入
                    double totalBalance = 0;
                    double totalDailyIncome = 0;
                    
                    for (final member in familyMembers) {
                      // TODO: 从零花钱记录中计算余额
                      // 这里暂时使用默认值
                      totalBalance += 0; // 应该从零花钱记录计算
                      totalDailyIncome += 0; // 应该从零花钱配置计算
                    }
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '零花钱概览',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    '¥${NumberFormat('#,##0.00').format(totalBalance)}',
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '每天零花钱收入',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '¥${NumberFormat('#,##0.00').format(totalDailyIncome)}',
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
                        const SizedBox(height: 8),
                        Text(
                          '家庭成员：${familyMembers.length}人',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // 家庭成员列表
              const Text(
                '家庭成员',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<AppProvider>(
                  builder: (context, appProvider, child) {
                    final familyMembers = appProvider.familyMembers;
                    
                    if (familyMembers.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    
                    return ListView.builder(
                      itemCount: familyMembers.length,
                      itemBuilder: (context, index) {
                        final member = familyMembers[index];
                        return _buildFamilyMemberCard(context, member);
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无家庭成员',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右上角添加家庭成员',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyMemberCard(BuildContext context, FamilyMember member) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FamilyMemberDetailScreen(member: member),
          ),
        );
      },
      child: Container(
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  member.avatar,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _getRoleText(member.role),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '零花钱: ¥0.00', // TODO: 从零花钱记录计算
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ],
        ),
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

  void _showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    String selectedRole = 'parent';
    String selectedAvatar = '👨';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加家庭成员'),
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
                final newMember = FamilyMember(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  avatar: selectedAvatar,
                  role: selectedRole,
                  isActive: true,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );
                
                context.read<AppProvider>().addFamilyMember(newMember);
                Navigator.of(context).pop();
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }
} 