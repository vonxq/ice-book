import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/account.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ice_book.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // 交易记录表
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        date TEXT NOT NULL,
        account TEXT
      )
    ''');

    // 账户表
    await db.execute('''
      CREATE TABLE accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        balance REAL NOT NULL,
        bankName TEXT,
        accountNumber TEXT,
        color TEXT
      )
    ''');
  }

  // 交易记录操作
  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<Transaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => Transaction.fromMap(maps[i]));
  }

  Future<int> updateTransaction(Transaction transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 账户操作
  Future<int> insertAccount(Account account) async {
    final db = await database;
    return await db.insert('accounts', account.toMap());
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('accounts');
    return List.generate(maps.length, (i) => Account.fromMap(maps[i]));
  }

  Future<int> updateAccount(Account account) async {
    final db = await database;
    return await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> deleteAccount(int id) async {
    final db = await database;
    return await db.delete(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 统计方法
  Future<double> getTotalIncome(DateTime start, DateTime end) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM transactions 
      WHERE type = 'income' AND date BETWEEN ? AND ?
    ''', [start.toIso8601String(), end.toIso8601String()]);
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> getTotalExpense(DateTime start, DateTime end) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total FROM transactions 
      WHERE type = 'expense' AND date BETWEEN ? AND ?
    ''', [start.toIso8601String(), end.toIso8601String()]);
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getCategoryStats(DateTime start, DateTime end) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT category, type, SUM(amount) as total 
      FROM transactions 
      WHERE date BETWEEN ? AND ?
      GROUP BY category, type
      ORDER BY total DESC
    ''', [start.toIso8601String(), end.toIso8601String()]);
  }
} 