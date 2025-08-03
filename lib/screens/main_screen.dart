import 'package:flutter/material.dart';
import 'package:ice_book/screens/home_screen.dart';
import 'package:ice_book/screens/bills_screen.dart';
import 'package:ice_book/screens/family_screen.dart';
import 'package:ice_book/screens/charts_screen.dart';
import 'package:ice_book/screens/profile_screen.dart';
import 'package:ice_book/screens/add_transaction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const BillsScreen(),
    const FamilyScreen(),
    const ChartsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
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
                    isSelected: _currentIndex == 0,
                    onTap: () => _setCurrentIndex(0),
                  ),
                ),
                // 记账按钮（中间，更大）
                Expanded(
                  child: _buildAddButton(context),
                ),
                // 账单
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.receipt_long,
                    label: '账单',
                    isSelected: _currentIndex == 1,
                    onTap: () => _setCurrentIndex(1),
                  ),
                ),
                // 我的小家
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.family_restroom,
                    label: '我的小家',
                    isSelected: _currentIndex == 2,
                    onTap: () => _setCurrentIndex(2),
                  ),
                ),
                // 图表
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.bar_chart,
                    label: '图表',
                    isSelected: _currentIndex == 3,
                    onTap: () => _setCurrentIndex(3),
                  ),
                ),
                // 我的
                Expanded(
                  child: _buildNavItem(
                    context,
                    icon: Icons.person,
                    label: '我的',
                    isSelected: _currentIndex == 4,
                    onTap: () => _setCurrentIndex(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AddTransactionScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
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