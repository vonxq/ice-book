import 'package:intl/intl.dart';

class Helpers {
  // 格式化金额
  static String formatAmount(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'zh_CN',
      symbol: '¥',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  // 格式化日期
  static String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy年MM月dd日');
    return formatter.format(date);
  }

  // 格式化时间
  static String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  // 格式化日期时间
  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('yyyy年MM月dd日 HH:mm');
    return formatter.format(date);
  }

  // 获取月份名称
  static String getMonthName(DateTime date) {
    final formatter = DateFormat('MM月');
    return formatter.format(date);
  }

  // 获取年份
  static String getYear(DateTime date) {
    final formatter = DateFormat('yyyy年');
    return formatter.format(date);
  }

  // 获取当前月份的开始和结束日期
  static Map<String, DateTime> getCurrentMonthRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return {'start': start, 'end': end};
  }

  // 获取指定月份的开始和结束日期
  static Map<String, DateTime> getMonthRange(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return {'start': start, 'end': end};
  }

  // 颜色字符串转Color
  static int hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
    }
    return int.parse(buffer.toString(), radix: 16);
  }

  // 获取随机颜色
  static String getRandomColor() {
    final colors = [
      '#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FFEAA7',
      '#DDA0DD', '#98D8C8', '#F7DC6F', '#BB8FCE', '#85C1E9',
    ];
    return colors[DateTime.now().millisecond % colors.length];
  }

  // 验证金额输入
  static bool isValidAmount(String amount) {
    if (amount.isEmpty) return false;
    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
    return regex.hasMatch(amount);
  }

  // 获取分类图标
  static String getCategoryIcon(String category) {
    const icons = {
      '餐饮': '🍽️',
      '交通': '🚗',
      '购物': '🛍️',
      '娱乐': '🎮',
      '医疗': '🏥',
      '教育': '📚',
      '住房': '🏠',
      '通讯': '📱',
      '其他': '📝',
      '工资': '💰',
      '奖金': '🎁',
      '投资': '📈',
      '兼职': '💼',
    };
    return icons[category] ?? '📝';
  }

  // 获取账户类型图标
  static String getAccountTypeIcon(String type) {
    const icons = {
      'cash': '💵',
      'bank': '🏦',
      'credit': '💳',
      'investment': '📊',
    };
    return icons[type] ?? '💳';
  }
} 