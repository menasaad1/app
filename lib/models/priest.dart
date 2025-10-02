class Priest {
  final String id;
  final String name;
  final DateTime ordinationDate;
  final String? church; // الكنيسة التي يخدم بها
  final String? rank; // الرتبة (قمص، أبونا، إلخ)
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Priest({
    required this.id,
    required this.name,
    required this.ordinationDate,
    this.church,
    this.rank,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Priest.fromMap(Map<String, dynamic> map) {
    return Priest(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      ordinationDate: map['ordinationDate'] is String 
          ? DateTime.parse(map['ordinationDate'])
          : (map['ordinationDate'] as DateTime),
      church: map['church'],
      rank: map['rank'],
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
      'church': church,
      'rank': rank,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Priest copyWith({
    String? id,
    String? name,
    DateTime? ordinationDate,
    String? church,
    String? rank,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Priest(
      id: id ?? this.id,
      name: name ?? this.name,
      ordinationDate: ordinationDate ?? this.ordinationDate,
      church: church ?? this.church,
      rank: rank ?? this.rank,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
