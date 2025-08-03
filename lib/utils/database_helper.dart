import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ice_book/models/user.dart';
import 'package:ice_book/models/family_member.dart';
import 'package:ice_book/models/transaction.dart';
import 'package:ice_book/models/category.dart';
import 'package:ice_book/models/account.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ice_book.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 用户表
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        avatar TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // 家庭成员表
    await db.execute('''
      CREATE TABLE family_members (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        avatar TEXT NOT NULL,
        role TEXT NOT NULL,
        isActive INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // 账户表
    await db.execute('''
      CREATE TABLE accounts (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        bankName TEXT NOT NULL,
        balance REAL NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // 分类表
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        type TEXT NOT NULL,
        sortOrder INTEGER NOT NULL,
        isDefault INTEGER NOT NULL
      )
    ''');

    // 交易记录表
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        accountId TEXT NOT NULL,
        categoryId TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        note TEXT NOT NULL,
        date TEXT NOT NULL,
        budgetId TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // 交易贡献人表
    await db.execute('''
      CREATE TABLE transaction_contributors (
        id TEXT PRIMARY KEY,
        transactionId TEXT NOT NULL,
        memberId TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // 零花钱配置表
    await db.execute('''
      CREATE TABLE pocket_money_configs (
        id TEXT PRIMARY KEY,
        memberId TEXT NOT NULL,
        dailyAmount REAL NOT NULL,
        accumulateToNext INTEGER NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT,
        isEnabled INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // 零花钱记录表
    await db.execute('''
      CREATE TABLE pocket_money_records (
        id TEXT PRIMARY KEY,
        memberId TEXT NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        transactionId TEXT,
        note TEXT NOT NULL,
        date TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // 预算表
    await db.execute('''
      CREATE TABLE budgets (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        usedAmount REAL NOT NULL,
        period TEXT NOT NULL,
        accumulateToNext INTEGER NOT NULL,
        warningThreshold REAL NOT NULL,
        isActive INTEGER NOT NULL,
        categoryId TEXT,
        startDate TEXT NOT NULL,
        endDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // 插入默认分类数据
    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      // 支出分类
      {'id': 'expense_food', 'name': '餐饮', 'icon': '🍽️', 'color': '#F59E0B', 'type': 'expense', 'sortOrder': 1, 'isDefault': 1},
      {'id': 'expense_transport', 'name': '交通', 'icon': '🚗', 'color': '#3B82F6', 'type': 'expense', 'sortOrder': 2, 'isDefault': 1},
      {'id': 'expense_shopping', 'name': '购物', 'icon': '🛒', 'color': '#10B981', 'type': 'expense', 'sortOrder': 3, 'isDefault': 1},
      {'id': 'expense_entertainment', 'name': '娱乐', 'icon': '🎮', 'color': '#8B5CF6', 'type': 'expense', 'sortOrder': 4, 'isDefault': 1},
      {'id': 'expense_medical', 'name': '医疗', 'icon': '🏥', 'color': '#EF4444', 'type': 'expense', 'sortOrder': 5, 'isDefault': 1},
      {'id': 'expense_education', 'name': '教育', 'icon': '📚', 'color': '#06B6D4', 'type': 'expense', 'sortOrder': 6, 'isDefault': 1},
      {'id': 'expense_housing', 'name': '住房', 'icon': '🏠', 'color': '#F97316', 'type': 'expense', 'sortOrder': 7, 'isDefault': 1},
      {'id': 'expense_other', 'name': '其他', 'icon': '📦', 'color': '#6B7280', 'type': 'expense', 'sortOrder': 8, 'isDefault': 1},
      
      // 收入分类
      {'id': 'income_salary', 'name': '工资', 'icon': '💰', 'color': '#10B981', 'type': 'income', 'sortOrder': 1, 'isDefault': 1},
      {'id': 'income_bonus', 'name': '奖金', 'icon': '🎁', 'color': '#F59E0B', 'type': 'income', 'sortOrder': 2, 'isDefault': 1},
      {'id': 'income_investment', 'name': '投资', 'icon': '📈', 'color': '#3B82F6', 'type': 'income', 'sortOrder': 3, 'isDefault': 1},
      {'id': 'income_part_time', 'name': '兼职', 'icon': '💼', 'color': '#8B5CF6', 'type': 'income', 'sortOrder': 4, 'isDefault': 1},
      {'id': 'income_other', 'name': '其他', 'icon': '📦', 'color': '#6B7280', 'type': 'income', 'sortOrder': 5, 'isDefault': 1},
    ];

    for (final category in defaultCategories) {
      await db.insert('categories', category);
    }
  }

  Future<void> initDatabase() async {
    await database;
  }

  // 关闭数据库
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
} 