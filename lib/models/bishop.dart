class Bishop {
  final String id;
  final String name;
  final DateTime ordinationDate;
  final String? diocese;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Bishop({
    required this.id,
    required this.name,
    required this.ordinationDate,
    this.diocese,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Bishop.fromMap(Map<String, dynamic> map) {
    return Bishop(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      ordinationDate: map['ordinationDate'] is String 
          ? DateTime.parse(map['ordinationDate'])
          : (map['ordinationDate'] as DateTime),
      diocese: map['diocese'],
      notes: map['notes'],
      createdAt: map['createdAt'] is String 
          ? DateTime.parse(map['createdAt'])
          : (map['createdAt'] as DateTime),
      updatedAt: map['updatedAt'] is String 
          ? DateTime.parse(map['updatedAt'])
          : (map['updatedAt'] as DateTime),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ordinationDate': ordinationDate.toIso8601String(),
      'diocese': diocese,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Bishop copyWith({
    String? id,
    String? name,
    DateTime? ordinationDate,
    String? diocese,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Bishop(
      id: id ?? this.id,
      name: name ?? this.name,
      ordinationDate: ordinationDate ?? this.ordinationDate,
      diocese: diocese ?? this.diocese,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

