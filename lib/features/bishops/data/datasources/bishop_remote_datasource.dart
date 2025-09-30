import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../domain/entities/bishop.dart';
import '../../domain/entities/bishop_filter.dart';

abstract class BishopRemoteDataSource {
  Stream<List<Bishop>> getBishops({BishopFilter? filter});
  Future<Bishop?> getBishopById(String id);
  Future<void> addBishop(Bishop bishop);
  Future<void> updateBishop(Bishop bishop);
  Future<void> deleteBishop(String id);
  Future<List<String>> getDioceses();
  Future<String> uploadBishopPhoto(String bishopId, String filePath);
  Future<void> deleteBishopPhoto(String photoUrl);
  Future<List<Bishop>> searchBishops(String query);
  Future<Map<String, int>> getBishopStatistics();
}

class BishopRemoteDataSourceImpl implements BishopRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  BishopRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  }) : _firestore = firestore,
       _storage = storage;

  @override
  Stream<List<Bishop>> getBishops({BishopFilter? filter}) {
    Query<Map<String, dynamic>> query = _firestore.collection('bishops');
    
    if (filter != null) {
      query = filter.applyToQuery(query);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Bishop.fromFirestore(doc)).toList();
    });
  }

  @override
  Future<Bishop?> getBishopById(String id) async {
    try {
      final doc = await _firestore.collection('bishops').doc(id).get();
      if (doc.exists) {
        return Bishop.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get bishop: $e');
    }
  }

  @override
  Future<void> addBishop(Bishop bishop) async {
    try {
      await _firestore.collection('bishops').doc(bishop.id).set(bishop.toMap());
    } catch (e) {
      throw Exception('Failed to add bishop: $e');
    }
  }

  @override
  Future<void> updateBishop(Bishop bishop) async {
    try {
      await _firestore.collection('bishops').doc(bishop.id).update(bishop.toMap());
    } catch (e) {
      throw Exception('Failed to update bishop: $e');
    }
  }

  @override
  Future<void> deleteBishop(String id) async {
    try {
      await _firestore.collection('bishops').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete bishop: $e');
    }
  }

  @override
  Future<List<String>> getDioceses() async {
    try {
      final snapshot = await _firestore.collection('dioceses').get();
      return snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to get dioceses: $e');
    }
  }

  @override
  Future<String> uploadBishopPhoto(String bishopId, String filePath) async {
    try {
      final file = File(filePath);
      final ref = _storage.ref().child('bishops/$bishopId/${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  @override
  Future<void> deleteBishopPhoto(String photoUrl) async {
    try {
      final ref = _storage.refFromURL(photoUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }

  @override
  Future<List<Bishop>> searchBishops(String query) async {
    try {
      final snapshot = await _firestore
          .collection('bishops')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();
      
      return snapshot.docs.map((doc) => Bishop.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to search bishops: $e');
    }
  }

  @override
  Future<Map<String, int>> getBishopStatistics() async {
    try {
      final snapshot = await _firestore.collection('bishops').get();
      final bishops = snapshot.docs.map((doc) => Bishop.fromFirestore(doc)).toList();
      
      final statistics = <String, int>{};
      
      // Count by diocese
      for (final bishop in bishops) {
        statistics[bishop.diocese] = (statistics[bishop.diocese] ?? 0) + 1;
      }
      
      return statistics;
    } catch (e) {
      throw Exception('Failed to get statistics: $e');
    }
  }
}
