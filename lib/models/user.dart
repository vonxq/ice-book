class User {
  final String id;
  final String name;
  final String avatar;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.avatar,
    this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? avatar,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 