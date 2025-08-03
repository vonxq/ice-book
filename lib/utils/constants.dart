class AppConstants {
  // 应用信息
  static const String appName = 'Ice Book';
  static const String appVersion = '1.0.0';
  
  // 交易类型
  static const String income = 'income';
  static const String expense = 'expense';
  
  // 账户类型
  static const String cash = 'cash';
  static const String bank = 'bank';
  static const String credit = 'credit';
  static const String investment = 'investment';
  
  // 支出分类
  static const List<String> expenseCategories = [
    '餐饮',
    '交通',
    '购物',
    '娱乐',
    '医疗',
    '教育',
    '住房',
    '通讯',
    '其他',
  ];
  
  // 收入分类
  static const List<String> incomeCategories = [
    '工资',
    '奖金',
    '投资',
    '兼职',
    '其他',
  ];
  
  // 颜色主题
  static const List<String> colors = [
    '#FF6B6B', // 红色
    '#4ECDC4', // 青色
    '#45B7D1', // 蓝色
    '#96CEB4', // 绿色
    '#FFEAA7', // 黄色
    '#DDA0DD', // 紫色
    '#98D8C8', // 薄荷绿
    '#F7DC6F', // 金黄色
    '#BB8FCE', // 淡紫色
    '#85C1E9', // 天蓝色
  ];
  
  // 图标映射
  static const Map<String, String> categoryIcons = {
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
  
  // 账户类型图标
  static const Map<String, String> accountTypeIcons = {
    'cash': '💵',
    'bank': '🏦',
    'credit': '💳',
    'investment': '📊',
  };
} 