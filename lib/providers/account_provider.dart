import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../services/database_service.dart';

class AccountProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Account> _accounts = [];
  bool _isLoading = false;

  List<Account> get accounts => _accounts;
  bool get isLoading => _isLoading;

  // 获取所有账户
  Future<void> loadAccounts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _accounts = await _databaseService.getAccounts();
    } catch (e) {
      print('加载账户失败: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 添加账户
  Future<void> addAccount(Account account) async {
    try {
      final id = await _databaseService.insertAccount(account);
      final newAccount = Account(
        id: id,
        name: account.name,
        type: account.type,
        balance: account.balance,
        bankName: account.bankName,
        accountNumber: account.accountNumber,
        color: account.color,
      );
      _accounts.add(newAccount);
      notifyListeners();
    } catch (e) {
      print('添加账户失败: $e');
    }
  }

  // 更新账户
  Future<void> updateAccount(Account account) async {
    try {
      await _databaseService.updateAccount(account);
      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _accounts[index] = account;
        notifyListeners();
      }
    } catch (e) {
      print('更新账户失败: $e');
    }
  }

  // 删除账户
  Future<void> deleteAccount(int id) async {
    try {
      await _databaseService.deleteAccount(id);
      _accounts.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      print('删除账户失败: $e');
    }
  }

  // 获取账户总资产
  double get totalAssets {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  // 根据类型获取账户
  List<Account> getAccountsByType(String type) {
    return _accounts.where((account) => account.type == type).toList();
  }
} 