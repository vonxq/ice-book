import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/models/category.dart';

class CategoryGrid extends StatelessWidget {
  final String type; // income 或 expense
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.type,
    this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final categories = appProvider.categories
            .where((category) => category.type == type)
            .toList();

        if (categories.isEmpty) {
          return _buildDefaultCategories(context);
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategoryId == category.id;
              
              return _buildCategoryItem(context, category, isSelected);
            },
          ),
        );
      },
    );
  }

  Widget _buildDefaultCategories(BuildContext context) {
    final defaultCategories = type == 'expense' ? _getDefaultExpenseCategories() : _getDefaultIncomeCategories();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: defaultCategories.length,
        itemBuilder: (context, index) {
          final category = defaultCategories[index];
          final isSelected = selectedCategoryId == category['id'];
          
          return _buildDefaultCategoryItem(context, category, isSelected);
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category, bool isSelected) {
    return GestureDetector(
      onTap: () => onCategorySelected(category.id),
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
              category.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              category.name,
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
  }

  Widget _buildDefaultCategoryItem(BuildContext context, Map<String, dynamic> category, bool isSelected) {
    return GestureDetector(
      onTap: () => onCategorySelected(category['id']),
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
              category['icon'],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 4),
            Text(
              category['name'],
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
  }

  List<Map<String, dynamic>> _getDefaultExpenseCategories() {
    return [
      {'id': 'expense_food', 'name': '餐饮', 'icon': '🍽️'},
      {'id': 'expense_transport', 'name': '交通', 'icon': '🚗'},
      {'id': 'expense_shopping', 'name': '购物', 'icon': '🛒'},
      {'id': 'expense_entertainment', 'name': '娱乐', 'icon': '🎮'},
      {'id': 'expense_medical', 'name': '医疗', 'icon': '🏥'},
      {'id': 'expense_education', 'name': '教育', 'icon': '📚'},
      {'id': 'expense_housing', 'name': '住房', 'icon': '🏠'},
      {'id': 'expense_other', 'name': '其他', 'icon': '📦'},
    ];
  }

  List<Map<String, dynamic>> _getDefaultIncomeCategories() {
    return [
      {'id': 'income_salary', 'name': '工资', 'icon': '💰'},
      {'id': 'income_bonus', 'name': '奖金', 'icon': '🎁'},
      {'id': 'income_investment', 'name': '投资', 'icon': '📈'},
      {'id': 'income_part_time', 'name': '兼职', 'icon': '💼'},
      {'id': 'income_other', 'name': '其他', 'icon': '📦'},
    ];
  }
} 