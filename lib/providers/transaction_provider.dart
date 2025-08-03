import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../services/database_service.dart';

class TransactionProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Transaction> _transactions = [];
  bool _isLoading = false;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // 获取所有交易记录
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _databaseService.getTransactions();
    } catch (e) {
      print('加载交易记录失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 添加交易记录
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final id = await _databaseService.insertTransaction(transaction);
      final newTransaction = Transaction(
        id: id,
        amount: transaction.amount,
        category: transaction.category,
        type: transaction.type,
        note: transaction.note,
        date: transaction.date,
        account: transaction.account,
      );
      _transactions.insert(0, newTransaction);
      notifyListeners();
    } catch (e) {
      print('添加交易记录失败: $e');
    }
  }

  // 更新交易记录
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _databaseService.updateTransaction(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      print('更新交易记录失败: $e');
    }
  }

  // 删除交易记录
  Future<void> deleteTransaction(int id) async {
    try {
      await _databaseService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      print('删除交易记录失败: $e');
    }
  }

  // 获取指定日期范围的交易记录
  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    try {
      return await _databaseService.getTransactionsByDateRange(start, end);
    } catch (e) {
      print('获取日期范围交易记录失败: $e');
      return [];
    }
  }

  // 获取总收入
  Future<double> getTotalIncome(DateTime start, DateTime end) async {
    try {
      return await _databaseService.getTotalIncome(start, end);
    } catch (e) {
      print('获取总收入失败: $e');
      return 0.0;
    }
  }

  // 获取总支出
  Future<double> getTotalExpense(DateTime start, DateTime end) async {
    try {
      return await _databaseService.getTotalExpense(start, end);
    } catch (e) {
      print('获取总支出失败: $e');
      return 0.0;
    }
  }

  // 获取分类统计
  Future<List<Map<String, dynamic>>> getCategoryStats(DateTime start, DateTime end) async {
    try {
      return await _databaseService.getCategoryStats(start, end);
    } catch (e) {
      print('获取分类统计失败: $e');
      return [];
    }
  }
} 