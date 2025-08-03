import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              Expanded(child: _buildToolItem(context, '账单', FontAwesomeIcons.receipt, () {})),
              const SizedBox(width: 12),
              Expanded(child: _buildToolItem(context, '我的小家', FontAwesomeIcons.users, () {})),
              const SizedBox(width: 12),
              Expanded(child: _buildToolItem(context, '预算管理', FontAwesomeIcons.wallet, () {})),
            ],
          ),
          const SizedBox(height: 12),
          // 第二行：资产管家、图表
          Row(
            children: [
              Expanded(child: _buildToolItem(context, '资产管家', FontAwesomeIcons.buildingColumns, () {})),
              const SizedBox(width: 12),
              Expanded(child: _buildToolItem(context, '图表', FontAwesomeIcons.chartLine, () {})),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()), // 占位
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