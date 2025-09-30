import 'package:cloud_firestore/cloud_firestore.dart';

class Bishop {
  final String id;
  final String name;
  final String title;
  final String diocese;
  final DateTime ordinationDate;
  final DateTime birthDate;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? biography;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;

  const Bishop({
    required this.id,
    required this.name,
    required this.title,
    required this.diocese,
    required this.ordinationDate,
    required this.birthDate,
    this.phoneNumber,
    this.email,
    this.address,
    this.biography,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  Bishop copyWith({
    String? id,
    String? name,
    String? title,
    String? diocese,
    DateTime? ordinationDate,
    DateTime? birthDate,
    String? phoneNumber,
    String? email,
    String? address,
    String? biography,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
  }) {
    return Bishop(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      diocese: diocese ?? this.diocese,
      ordinationDate: ordinationDate ?? this.ordinationDate,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      biography: biography ?? this.biography,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'diocese': diocese,
      'ordinationDate': Timestamp.fromDate(ordinationDate),
      'birthDate': Timestamp.fromDate(birthDate),
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'biography': biography,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  factory Bishop.fromMap(Map<String, dynamic> map) {
    return Bishop(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      diocese: map['diocese'] ?? '',
      ordinationDate: (map['ordinationDate'] as Timestamp).toDate(),
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      address: map['address'],
      biography: map['biography'],
      photoUrl: map['photoUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
      updatedBy: map['updatedBy'] ?? '',
    );
  }

  factory Bishop.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bishop.fromMap({...data, 'id': doc.id});
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Bishop && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Bishop(id: $id, name: $name, title: $title, diocese: $diocese)';
  }
}
