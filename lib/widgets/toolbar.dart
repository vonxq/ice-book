import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ice_book/screens/bills_screen.dart';
import 'package:ice_book/screens/budget_screen.dart';
import 'package:ice_book/screens/assets_screen.dart';
import 'package:ice_book/screens/family_screen.dart';
import 'package:ice_book/screens/charts_screen.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 第一行：账单、我的小家、预算管理
          Row(
            children: [
              Expanded(child: _buildToolItem(context, '账单', FontAwesomeIcons.receipt, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BillsScreen()),
                );
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildToolItem(context, '我的小家', FontAwesomeIcons.users, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FamilyScreen()),
                );
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildToolItem(context, '预算管理', FontAwesomeIcons.wallet, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BudgetScreen()),
                );
              })),
            ],
          ),
          const SizedBox(height: 12),
          // 第二行：资产管家、图表
          Row(
            children: [
              Expanded(child: _buildToolItem(context, '资产管家', FontAwesomeIcons.buildingColumns, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AssetsScreen()),
                );
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildToolItem(context, '图表', FontAwesomeIcons.chartLine, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ChartsScreen()),
                );
              })),
              const SizedBox(width: 12),
              // 占位，保持布局平衡
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
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
          children: [
            FaIcon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 