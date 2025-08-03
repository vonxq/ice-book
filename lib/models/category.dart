class Category {
  final String id;
  final String name;
  final String icon;
  final String color;
  final String type; // income, expense
  final int sortOrder;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    required this.sortOrder,
    required this.isDefault,
  });

  Category copyWith({
    String? id,
    String? name,
    String? icon,
    String? color,
    String? type,
    int? sortOrder,
    bool? isDefault,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
    );
  }
} 