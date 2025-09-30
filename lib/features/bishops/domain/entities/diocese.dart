class Diocese {
  final String id;
  final String name;
  final String? description;
  final String? region;
  final String? country;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Diocese({
    required this.id,
    required this.name,
    this.description,
    this.region,
    this.country,
    required this.createdAt,
    required this.updatedAt,
  });

  Diocese copyWith({
    String? id,
    String? name,
    String? description,
    String? region,
    String? country,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Diocese(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      region: region ?? this.region,
      country: country ?? this.country,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'region': region,
      'country': country,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Diocese.fromMap(Map<String, dynamic> map) {
    return Diocese(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      region: map['region'],
      country: map['country'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Diocese && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Diocese(id: $id, name: $name, region: $region)';
  }
}
