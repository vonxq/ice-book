class FamilyMember {
  final String id;
  final String name;
  final String avatar;
  final String role; // parent, child, other
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.avatar,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  FamilyMember copyWith({
    String? id,
    String? name,
    String? avatar,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 