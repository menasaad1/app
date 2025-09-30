import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/bishop.dart';
import '../../domain/entities/bishop_filter.dart';
import '../datasources/bishop_remote_datasource.dart';
import '../datasources/bishop_local_datasource.dart';
import '../../domain/repositories/bishop_repository.dart';

class BishopRepositoryImpl implements BishopRepository {
  final BishopRemoteDataSource remoteDataSource;
  final BishopLocalDataSource localDataSource;

  BishopRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<List<Bishop>> getBishops({BishopFilter? filter}) {
    return remoteDataSource.getBishops(filter: filter);
  }

  @override
  Future<Bishop?> getBishopById(String id) async {
    try {
      return await remoteDataSource.getBishopById(id);
    } catch (e) {
      // Fallback to local data
      return await localDataSource.getBishopById(id);
    }
  }

  @override
  Future<String> addBishop(Bishop bishop) async {
    try {
      final id = const Uuid().v4();
      final bishopWithId = bishop.copyWith(id: id);
      
      await remoteDataSource.addBishop(bishopWithId);
      await localDataSource.addBishop(bishopWithId);
      
      return id;
    } catch (e) {
      // Fallback to local storage
      final id = const Uuid().v4();
      final bishopWithId = bishop.copyWith(id: id);
      await localDataSource.addBishop(bishopWithId);
      return id;
    }
  }

  @override
  Future<void> updateBishop(Bishop bishop) async {
    try {
      await remoteDataSource.updateBishop(bishop);
      await localDataSource.updateBishop(bishop);
    } catch (e) {
      // Fallback to local storage
      await localDataSource.updateBishop(bishop);
    }
  }

  @override
  Future<void> deleteBishop(String id) async {
    try {
      await remoteDataSource.deleteBishop(id);
      await localDataSource.deleteBishop(id);
    } catch (e) {
      // Fallback to local storage
      await localDataSource.deleteBishop(id);
    }
  }

  @override
  Future<List<String>> getDioceses() async {
    try {
      return await remoteDataSource.getDioceses();
    } catch (e) {
      return await localDataSource.getDioceses();
    }
  }

  @override
  Future<String> uploadBishopPhoto(String bishopId, String filePath) async {
    try {
      return await remoteDataSource.uploadBishopPhoto(bishopId, filePath);
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  @override
  Future<void> deleteBishopPhoto(String photoUrl) async {
    try {
      await remoteDataSource.deleteBishopPhoto(photoUrl);
    } catch (e) {
      // Photo deletion is not critical, so we don't throw
    }
  }

  @override
  Future<List<Bishop>> searchBishops(String query) async {
    try {
      return await remoteDataSource.searchBishops(query);
    } catch (e) {
      return await localDataSource.searchBishops(query);
    }
  }

  @override
  Future<Map<String, int>> getBishopStatistics() async {
    try {
      return await remoteDataSource.getBishopStatistics();
    } catch (e) {
      return await localDataSource.getBishopStatistics();
    }
  }
}
