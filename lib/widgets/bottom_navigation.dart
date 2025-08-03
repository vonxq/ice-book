import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // 主页
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.home,
                  label: '主页',
                  isSelected: true,
                  onTap: () {},
                ),
              ),
              // 我的小家
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.family_restroom,
                  label: '我的小家',
                  isSelected: false,
                  onTap: () {},
                ),
              ),
              // 记账按钮（占位）
              const Expanded(child: SizedBox()),
              // 图表
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.bar_chart,
                  label: '图表',
                  isSelected: false,
                  onTap: () {},
                ),
              ),
              // 我的
              Expanded(
                child: _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: '我的',
                  isSelected: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
} 