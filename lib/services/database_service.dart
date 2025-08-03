import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/transaction.dart' as app_models;
import '../models/account.dart';

class DatabaseService {
  static sqflite.Database? _database;
  static SharedPreferences? _prefs;

  Future<sqflite.Database?> get database async {
    if (kIsWeb) {
      return null; // web平台不使用SQLite
    }
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initDatabase() async {
    // 在web平台上使用SharedPreferences作为临时解决方案
    if (kIsWeb) {
      _prefs = await SharedPreferences.getInstance();
      throw UnsupportedError('SQLite not supported on web platform');
    } else {
      sqflite.databaseFactory = databaseFactoryFfi;
      String path = join(await sqflite.getDatabasesPath(), 'ice_book.db');
      return await sqflite.openDatabase(
        path,
        version: 1,
        onCreate: _createTables,
      );
    }
  }

  Future<void> _createTables(sqflite.Database db, int version) async {
    if (kIsWeb) return; // web平台跳过表创建
    
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
  Future<int> insertTransaction(app_models.Transaction transaction) async {
    if (kIsWeb) {
      final transactions = await _getTransactionsFromPrefs();
      final newId = transactions.isEmpty ? 1 : (transactions.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newTransaction = app_models.Transaction(
        id: newId,
        amount: transaction.amount,
        category: transaction.category,
        type: transaction.type,
        note: transaction.note,
        date: transaction.date,
        account: transaction.account,
      );
      transactions.add(newTransaction);
      await _saveTransactionsToPrefs(transactions);
      return newId;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      return await db.insert('transactions', transaction.toMap());
    }
  }

  Future<List<app_models.Transaction>> getTransactions() async {
    if (kIsWeb) {
      return await _getTransactionsFromPrefs();
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
      return List.generate(maps.length, (i) => app_models.Transaction.fromMap(maps[i]));
    }
  }

  Future<List<app_models.Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    if (kIsWeb) {
      final transactions = await _getTransactionsFromPrefs();
      return transactions.where((t) =>
        t.date.isAfter(start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1)))
      ).toList();
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      final List<Map<String, dynamic>> maps = await db.query(
        'transactions',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [start.toIso8601String(), end.toIso8601String()],
        orderBy: 'date DESC',
      );
      return List.generate(maps.length, (i) => app_models.Transaction.fromMap(maps[i]));
    }
  }

  Future<int> updateTransaction(app_models.Transaction transaction) async {
    if (kIsWeb) {
      final transactions = await _getTransactionsFromPrefs();
      final index = transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        transactions[index] = transaction;
        await _saveTransactionsToPrefs(transactions);
        return 1;
      }
      return 0;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      return await db.update(
        'transactions',
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
    }
  }

  Future<int> deleteTransaction(int id) async {
    if (kIsWeb) {
      final transactions = await _getTransactionsFromPrefs();
      transactions.removeWhere((t) => t.id == id);
      await _saveTransactionsToPrefs(transactions);
      return 1;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      return await db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // SharedPreferences 辅助方法
  Future<List<app_models.Transaction>> _getTransactionsFromPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    final transactionsJson = _prefs!.getStringList('transactions') ?? [];
    return transactionsJson
        .map((json) => app_models.Transaction.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveTransactionsToPrefs(List<app_models.Transaction> transactions) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    final transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toMap()))
        .toList();
    await _prefs!.setStringList('transactions', transactionsJson);
  }

  // 账户操作
  Future<int> insertAccount(Account account) async {
    if (kIsWeb) {
      final accounts = await _getAccountsFromPrefs();
      final newId = accounts.isEmpty ? 1 : (accounts.map((a) => a.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newAccount = Account(
        id: newId,
        name: account.name,
        type: account.type,
        balance: account.balance,
        bankName: account.bankName,
        accountNumber: account.accountNumber,
        color: account.color,
      );
      accounts.add(newAccount);
      await _saveAccountsToPrefs(accounts);
      return newId;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      return await db.insert('accounts', account.toMap());
    }
  }

  Future<List<Account>> getAccounts() async {
    if (kIsWeb) {
      return await _getAccountsFromPrefs();
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      final List<Map<String, dynamic>> maps = await db.query('accounts');
      return List.generate(maps.length, (i) => Account.fromMap(maps[i]));
    }
  }

  Future<int> updateAccount(Account account) async {
    if (kIsWeb) {
      final accounts = await _getAccountsFromPrefs();
      final index = accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        accounts[index] = account;
        await _saveAccountsToPrefs(accounts);
        return 1;
      }
      return 0;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      return await db.update(
        'accounts',
        account.toMap(),
        where: 'id = ?',
        whereArgs: [account.id],
      );
    }
  }

  Future<int> deleteAccount(int id) async {
    if (kIsWeb) {
      final accounts = await _getAccountsFromPrefs();
      accounts.removeWhere((a) => a.id == id);
      await _saveAccountsToPrefs(accounts);
      return 1;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      return await db.delete(
        'accounts',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // SharedPreferences 账户辅助方法
  Future<List<Account>> _getAccountsFromPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    final accountsJson = _prefs!.getStringList('accounts') ?? [];
    return accountsJson
        .map((json) => Account.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveAccountsToPrefs(List<Account> accounts) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    final accountsJson = accounts
        .map((account) => jsonEncode(account.toMap()))
        .toList();
    await _prefs!.setStringList('accounts', accountsJson);
  }

  // 统计方法
  Future<double> getTotalIncome(DateTime start, DateTime end) async {
    if (kIsWeb) {
      final transactions = await _getTransactionsFromPrefs();
      double total = 0.0;
      for (final transaction in transactions) {
        if (transaction.type == 'income' &&
            transaction.date.isAfter(start.subtract(const Duration(days: 1))) &&
            transaction.date.isBefore(end.add(const Duration(days: 1)))) {
          total += transaction.amount;
        }
      }
      return total;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      final result = await db.rawQuery('''
        SELECT SUM(amount) as total FROM transactions 
        WHERE type = 'income' AND date BETWEEN ? AND ?
      ''', [start.toIso8601String(), end.toIso8601String()]);
      return (result.first['total'] as num?)?.toDouble() ?? 0.0;
    }
  }

  Future<double> getTotalExpense(DateTime start, DateTime end) async {
    if (kIsWeb) {
      final transactions = await _getTransactionsFromPrefs();
      double total = 0.0;
      for (final transaction in transactions) {
        if (transaction.type == 'expense' &&
            transaction.date.isAfter(start.subtract(const Duration(days: 1))) &&
            transaction.date.isBefore(end.add(const Duration(days: 1)))) {
          total += transaction.amount;
        }
      }
      return total;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      final result = await db.rawQuery('''
        SELECT SUM(amount) as total FROM transactions 
        WHERE type = 'expense' AND date BETWEEN ? AND ?
      ''', [start.toIso8601String(), end.toIso8601String()]);
      return (result.first['total'] as num?)?.toDouble() ?? 0.0;
    }
  }

  Future<List<Map<String, dynamic>>> getCategoryStats(DateTime start, DateTime end) async {
    if (kIsWeb) {
      final transactions = await _getTransactionsFromPrefs();
      final filteredTransactions = transactions.where((t) =>
        t.date.isAfter(start.subtract(const Duration(days: 1))) &&
        t.date.isBefore(end.add(const Duration(days: 1)))
      ).toList();
      
      final Map<String, Map<String, dynamic>> categoryStats = {};
      
      for (final transaction in filteredTransactions) {
        final key = '${transaction.category}_${transaction.type}';
        if (!categoryStats.containsKey(key)) {
          categoryStats[key] = {
            'category': transaction.category,
            'type': transaction.type,
            'total': 0.0,
          };
        }
        categoryStats[key]!['total'] = (categoryStats[key]!['total'] as double) + transaction.amount;
      }
      
      final result = categoryStats.values.toList();
      result.sort((a, b) => (b['total'] as double).compareTo(a['total'] as double));
      return result;
    } else {
      final db = await database;
      if (db == null) throw UnsupportedError('Database not available');
      return await db.rawQuery('''
        SELECT category, type, SUM(amount) as total 
        FROM transactions 
        WHERE date BETWEEN ? AND ?
        GROUP BY category, type
        ORDER BY total DESC
      ''', [start.toIso8601String(), end.toIso8601String()]);
    }
  }
} 