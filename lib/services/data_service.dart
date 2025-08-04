import 'package:ice_book/models/user.dart';
import 'package:ice_book/models/family_member.dart';
import 'package:ice_book/models/transaction.dart';
import 'package:ice_book/models/category.dart';
import 'package:ice_book/models/account.dart';
import 'package:ice_book/models/budget.dart';
import 'package:ice_book/models/pocket_money_config.dart';
import 'package:ice_book/models/pocket_money_record.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // 初始化默认数据
  Future<void> initializeDefaultData() async {
    // 初始化默认分类
    await _initializeDefaultCategories();
    
    // 初始化默认账户
    await _initializeDefaultAccounts();
  }

  Future<void> _initializeDefaultCategories() async {
    // 支出分类
    final expenseCategories = [
      Category(
        id: 'expense_food',
        name: '餐饮',
        icon: '🍽️',
        color: '#F59E0B',
        type: 'expense',
        sortOrder: 1,
        isDefault: true,
      ),
      Category(
        id: 'expense_transport',
        name: '交通',
        icon: '🚗',
        color: '#3B82F6',
        type: 'expense',
        sortOrder: 2,
        isDefault: true,
      ),
      Category(
        id: 'expense_shopping',
        name: '购物',
        icon: '🛒',
        color: '#10B981',
        type: 'expense',
        sortOrder: 3,
        isDefault: true,
      ),
      Category(
        id: 'expense_entertainment',
        name: '娱乐',
        icon: '🎮',
        color: '#8B5CF6',
        type: 'expense',
        sortOrder: 4,
        isDefault: true,
      ),
      Category(
        id: 'expense_medical',
        name: '医疗',
        icon: '🏥',
        color: '#EF4444',
        type: 'expense',
        sortOrder: 5,
        isDefault: true,
      ),
      Category(
        id: 'expense_education',
        name: '教育',
        icon: '📚',
        color: '#06B6D4',
        type: 'expense',
        sortOrder: 6,
        isDefault: true,
      ),
      Category(
        id: 'expense_housing',
        name: '住房',
        icon: '🏠',
        color: '#F97316',
        type: 'expense',
        sortOrder: 7,
        isDefault: true,
      ),
      Category(
        id: 'expense_other',
        name: '其他',
        icon: '📦',
        color: '#6B7280',
        type: 'expense',
        sortOrder: 8,
        isDefault: true,
      ),
    ];

    // 收入分类
    final incomeCategories = [
      Category(
        id: 'income_salary',
        name: '工资',
        icon: '💰',
        color: '#10B981',
        type: 'income',
        sortOrder: 1,
        isDefault: true,
      ),
      Category(
        id: 'income_bonus',
        name: '奖金',
        icon: '🎁',
        color: '#F59E0B',
        type: 'income',
        sortOrder: 2,
        isDefault: true,
      ),
      Category(
        id: 'income_investment',
        name: '投资',
        icon: '📈',
        color: '#3B82F6',
        type: 'income',
        sortOrder: 3,
        isDefault: true,
      ),
      Category(
        id: 'income_part_time',
        name: '兼职',
        icon: '💼',
        color: '#8B5CF6',
        type: 'income',
        sortOrder: 4,
        isDefault: true,
      ),
      Category(
        id: 'income_other',
        name: '其他',
        icon: '📦',
        color: '#6B7280',
        type: 'income',
        sortOrder: 5,
        isDefault: true,
      ),
    ];

    // 这里应该保存到数据库，暂时使用内存存储
    // TODO: 实现数据库存储
  }

  Future<void> _initializeDefaultAccounts() async {
    // 默认账户列表
    final defaultAccounts = [
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

    // 这里应该保存到数据库，暂时使用内存存储
    // TODO: 实现数据库存储
  }

  // 获取用户信息
  Future<User?> getUser() async {
    // TODO: 从数据库获取用户信息
    return null;
  }

  // 保存用户信息
  Future<void> saveUser(User user) async {
    // TODO: 保存用户信息到数据库
  }

  // 获取家庭成员列表
  Future<List<FamilyMember>> getFamilyMembers() async {
    // TODO: 从数据库获取家庭成员列表
    return [];
  }

  // 保存家庭成员
  Future<void> saveFamilyMember(FamilyMember member) async {
    // TODO: 保存家庭成员到数据库
  }

  // 删除家庭成员
  Future<void> deleteFamilyMember(String memberId) async {
    // TODO: 从数据库删除家庭成员
  }

  // 获取交易记录列表
  Future<List<Transaction>> getTransactions() async {
    // TODO: 从数据库获取交易记录列表
    return [];
  }

  // 保存交易记录
  Future<void> saveTransaction(Transaction transaction) async {
    // TODO: 保存交易记录到数据库
  }

  // 删除交易记录
  Future<void> deleteTransaction(String transactionId) async {
    // TODO: 从数据库删除交易记录
  }

  // 获取分类列表
  Future<List<Category>> getCategories() async {
    // TODO: 从数据库获取分类列表
    return [];
  }

  // 保存分类
  Future<void> saveCategory(Category category) async {
    // TODO: 保存分类到数据库
  }

  // 获取账户列表
  Future<List<Account>> getAccounts() async {
    // TODO: 从数据库获取账户列表
    return [];
  }

  // 保存账户
  Future<void> saveAccount(Account account) async {
    // TODO: 保存账户到数据库
  }

  // 删除账户
  Future<void> deleteAccount(String accountId) async {
    // TODO: 从数据库删除账户
  }

  // 获取预算列表
  Future<List<Budget>> getBudgets() async {
    // TODO: 从数据库获取预算列表
    return [];
  }

  // 保存预算
  Future<void> saveBudget(Budget budget) async {
    // TODO: 保存预算到数据库
  }

  // 删除预算
  Future<void> deleteBudget(String budgetId) async {
    // TODO: 从数据库删除预算
  }

  // 获取零花钱配置
  Future<List<PocketMoneyConfig>> getPocketMoneyConfigs() async {
    // TODO: 从数据库获取零花钱配置
    return [];
  }

  // 保存零花钱配置
  Future<void> savePocketMoneyConfig(PocketMoneyConfig config) async {
    // TODO: 保存零花钱配置到数据库
  }

  // 获取零花钱记录
  Future<List<PocketMoneyRecord>> getPocketMoneyRecords() async {
    // TODO: 从数据库获取零花钱记录
    return [];
  }

  // 保存零花钱记录
  Future<void> savePocketMoneyRecord(PocketMoneyRecord record) async {
    // TODO: 保存零花钱记录到数据库
  }

  // 计算零花钱余额
  Future<double> calculatePocketMoneyBalance(String memberId) async {
    // TODO: 计算指定成员的零花钱余额
    return 0.0;
  }

  // 获取统计数据
  Future<Map<String, dynamic>> getStatistics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // TODO: 获取指定时间范围的统计数据
    return {
      'totalIncome': 0.0,
      'totalExpense': 0.0,
      'balance': 0.0,
      'categoryStats': {},
      'memberStats': {},
    };
  }
} 