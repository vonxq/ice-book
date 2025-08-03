import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ice_book/providers/app_provider.dart';
import 'package:ice_book/widgets/overview_card.dart';
import 'package:ice_book/widgets/toolbar.dart';
import 'package:ice_book/widgets/transaction_list.dart';
import 'package:ice_book/widgets/bottom_navigation.dart';
import 'package:ice_book/screens/add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 初始化默认分类数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().initializeSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // 概览卡片
            const OverviewCard(),
            
            // 工具栏
            const Toolbar(),
            
            // 交易列表
            const Expanded(
              child: TransactionList(),
            ),
          ],
        ),
      ),
    );
  }
} 