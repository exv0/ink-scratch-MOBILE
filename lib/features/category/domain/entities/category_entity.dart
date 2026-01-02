class CategoryEntity {
  final String id;
  final String name;
  final String? description;
  final int color; // ✅ Added color field
  final DateTime createdAt;

  CategoryEntity({
    required this.id,
    required this.name,
    this.description,
    required this.color, // ✅ Fixed: changed from int color to this.color
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color, // ✅ Added color to map
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      color: map['color'] ?? 0xFF000000, // ✅ Added color with default
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  CategoryEntity copyWith({
    String? id,
    String? name,
    String? description,
    int? color, // ✅ Added color parameter
    DateTime? createdAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color, // ✅ Added color
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
