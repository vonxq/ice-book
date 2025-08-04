import 'package:flutter/material.dart';
import 'package:ice_book/models/user.dart';
import 'package:ice_book/models/family_member.dart';
import 'package:ice_book/models/transaction.dart';
import 'package:ice_book/models/category.dart';
import 'package:ice_book/models/account.dart';
import 'package:ice_book/services/data_service.dart';

class AppProvider extends ChangeNotifier {
  User? _currentUser;
  List<FamilyMember> _familyMembers = [];
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  List<Account> _accounts = [];
  DateTime _selectedDate = DateTime.now();
  final DataService _dataService = DataService();

  User? get currentUser => _currentUser;
  List<FamilyMember> get familyMembers => _familyMembers;
  List<Transaction> get transactions => _transactions;
  List<Category> get categories => _categories;
  List<Account> get accounts => _accounts;
  DateTime get selectedDate => _selectedDate;

  // 初始化应用数据
  Future<void> initializeApp() async {
    await _dataService.initializeDefaultData();
    await _loadCategories();
    await _loadAccounts();
    await _loadTransactions();
    await _loadFamilyMembers();
    notifyListeners();
  }

  // 加载分类数据
  Future<void> _loadCategories() async {
    _categories = await _dataService.getCategories();
    // 如果没有分类数据，初始化默认分类
    if (_categories.isEmpty) {
      _categories = [
        const Category(
          id: 'expense_food',
          name: '餐饮',
          icon: '🍽️',
          color: '#F59E0B',
          type: 'expense',
          sortOrder: 1,
          isDefault: true,
        ),
        const Category(
          id: 'expense_transport',
          name: '交通',
          icon: '🚗',
          color: '#3B82F6',
          type: 'expense',
          sortOrder: 2,
          isDefault: true,
        ),
        const Category(
          id: 'expense_shopping',
          name: '购物',
          icon: '🛒',
          color: '#10B981',
          type: 'expense',
          sortOrder: 3,
          isDefault: true,
        ),
        const Category(
          id: 'expense_entertainment',
          name: '娱乐',
          icon: '🎮',
          color: '#8B5CF6',
          type: 'expense',
          sortOrder: 4,
          isDefault: true,
        ),
        const Category(
          id: 'expense_medical',
          name: '医疗',
          icon: '🏥',
          color: '#EF4444',
          type: 'expense',
          sortOrder: 5,
          isDefault: true,
        ),
        const Category(
          id: 'expense_education',
          name: '教育',
          icon: '📚',
          color: '#06B6D4',
          type: 'expense',
          sortOrder: 6,
          isDefault: true,
        ),
        const Category(
          id: 'expense_housing',
          name: '住房',
          icon: '🏠',
          color: '#F97316',
          type: 'expense',
          sortOrder: 7,
          isDefault: true,
        ),
        const Category(
          id: 'expense_other',
          name: '其他',
          icon: '📦',
          color: '#6B7280',
          type: 'expense',
          sortOrder: 8,
          isDefault: true,
        ),
        const Category(
          id: 'income_salary',
          name: '工资',
          icon: '💰',
          color: '#10B981',
          type: 'income',
          sortOrder: 1,
          isDefault: true,
        ),
        const Category(
          id: 'income_bonus',
          name: '奖金',
          icon: '🎁',
          color: '#F59E0B',
          type: 'income',
          sortOrder: 2,
          isDefault: true,
        ),
        const Category(
          id: 'income_investment',
          name: '投资',
          icon: '📈',
          color: '#3B82F6',
          type: 'income',
          sortOrder: 3,
          isDefault: true,
        ),
        const Category(
          id: 'income_part_time',
          name: '兼职',
          icon: '💼',
          color: '#8B5CF6',
          type: 'income',
          sortOrder: 4,
          isDefault: true,
        ),
        const Category(
          id: 'income_other',
          name: '其他',
          icon: '📦',
          color: '#6B7280',
          type: 'income',
          sortOrder: 5,
          isDefault: true,
        ),
      ];
    }
  }

  // 加载账户数据
  Future<void> _loadAccounts() async {
    _accounts = await _dataService.getAccounts();
    // 如果没有账户数据，创建默认现金账户
    if (_accounts.isEmpty) {
      _accounts = [
        Account(
          id: 'account_cash',
          userId: 'user_001',
          name: '现金',
          type: 'cash',
          bankName: '',
          balance: 0.0,
          icon: '💰',
          color: '#10B981',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
  }

  // 加载交易记录
  Future<void> _loadTransactions() async {
    _transactions = await _dataService.getTransactions();
  }

  // 加载家庭成员
  Future<void> _loadFamilyMembers() async {
    _familyMembers = await _dataService.getFamilyMembers();
  }

  // 设置当前用户
  void setCurrentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  // 设置家庭成员
  void setFamilyMembers(List<FamilyMember> members) {
    _familyMembers = members;
    notifyListeners();
  }

  // 添加家庭成员
  Future<void> addFamilyMember(FamilyMember member) async {
    await _dataService.saveFamilyMember(member);
    _familyMembers.add(member);
    notifyListeners();
  }

  // 更新家庭成员
  Future<void> updateFamilyMember(FamilyMember member) async {
    await _dataService.saveFamilyMember(member);
    final index = _familyMembers.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      _familyMembers[index] = member;
      notifyListeners();
    }
  }

  // 删除家庭成员
  Future<void> removeFamilyMember(String memberId) async {
    await _dataService.deleteFamilyMember(memberId);
    _familyMembers.removeWhere((member) => member.id == memberId);
    notifyListeners();
  }

  // 设置交易记录
  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  // 添加交易记录
  Future<void> addTransaction(Transaction transaction) async {
    await _dataService.saveTransaction(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  // 更新交易记录
  Future<void> updateTransaction(Transaction transaction) async {
    await _dataService.saveTransaction(transaction);
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
    }
  }

  // 删除交易记录
  Future<void> removeTransaction(String transactionId) async {
    await _dataService.deleteTransaction(transactionId);
    _transactions.removeWhere((transaction) => transaction.id == transactionId);
    notifyListeners();
  }

  // 设置分类
  void setCategories(List<Category> categories) {
    _categories = categories;
    notifyListeners();
  }

  // 添加分类
  Future<void> addCategory(Category category) async {
    await _dataService.saveCategory(category);
    _categories.add(category);
    notifyListeners();
  }

  // 设置账户
  void setAccounts(List<Account> accounts) {
    _accounts = accounts;
    notifyListeners();
  }

  // 添加账户
  Future<void> addAccount(Account account) async {
    await _dataService.saveAccount(account);
    _accounts.add(account);
    notifyListeners();
  }

  // 更新账户
  Future<void> updateAccount(Account account) async {
    await _dataService.saveAccount(account);
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _accounts[index] = account;
      notifyListeners();
    }
  }

  // 删除账户
  Future<void> removeAccount(String accountId) async {
    await _dataService.deleteAccount(accountId);
    _accounts.removeWhere((account) => account.id == accountId);
    notifyListeners();
  }

  // 设置选中日期
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // 获取当月收入
  double get monthlyIncome {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return _transactions
        .where((t) => t.type == 'income' && 
                      t.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
                      t.date.isBefore(endOfMonth.add(const Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // 获取当月支出
  double get monthlyExpense {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return _transactions
        .where((t) => t.type == 'expense' && 
                      t.date.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
                      t.date.isBefore(endOfMonth.add(const Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // 获取当月结余
  double get monthlyBalance => monthlyIncome - monthlyExpense;

  // 获取总资产
  double get totalAssets {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  // 获取总负债
  double get totalLiabilities {
    return _accounts
        .where((account) => account.type == 'credit')
        .fold(0.0, (sum, account) => sum + account.balance.abs());
  }

  // 获取净资产
  double get netAssets => totalAssets - totalLiabilities;
} 