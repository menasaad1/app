import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../domain/entities/bishop.dart';
import '../../domain/entities/bishop_filter.dart';
import '../../data/repositories/bishop_repository_impl.dart';
import '../../data/datasources/bishop_remote_datasource.dart';
import '../../data/datasources/bishop_local_datasource.dart';

// Providers
final bishopRepositoryProvider = Provider<BishopRepositoryImpl>((ref) {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  
  final remoteDataSource = BishopRemoteDataSourceImpl(
    firestore: firestore,
    storage: storage,
  );
  
  final localDataSource = BishopLocalDataSourceImpl();
  
  return BishopRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final bishopsProvider = StreamProvider.family<List<Bishop>, BishopFilter?>((ref, filter) {
  final repository = ref.watch(bishopRepositoryProvider);
  return repository.getBishops(filter: filter);
});

final bishopByIdProvider = FutureProvider.family<Bishop?, String>((ref, id) {
  final repository = ref.watch(bishopRepositoryProvider);
  return repository.getBishopById(id);
});

final diocesesProvider = FutureProvider<List<String>>((ref) {
  final repository = ref.watch(bishopRepositoryProvider);
  return repository.getDioceses();
});

final bishopStatisticsProvider = FutureProvider<Map<String, int>>((ref) {
  final repository = ref.watch(bishopRepositoryProvider);
  return repository.getBishopStatistics();
});

final searchBishopsProvider = FutureProvider.family<List<Bishop>, String>((ref, query) {
  final repository = ref.watch(bishopRepositoryProvider);
  return repository.searchBishops(query);
});

// Filter Provider
final bishopFilterProvider = StateNotifierProvider<BishopFilterNotifier, BishopFilter>((ref) {
  return BishopFilterNotifier();
});

class BishopFilterNotifier extends StateNotifier<BishopFilter> {
  BishopFilterNotifier() : super(const BishopFilter());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateDiocese(String? diocese) {
    state = state.copyWith(diocese: diocese);
  }

  void updateDateRange(DateTime? startDate, DateTime? endDate) {
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
    );
  }

  void updateSortBy(BishopSortBy sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void updateSortOrder(bool ascending) {
    state = state.copyWith(ascending: ascending);
  }

  void clearFilters() {
    state = const BishopFilter();
  }

  void toggleSortOrder() {
    state = state.copyWith(ascending: !state.ascending);
  }
}

// Bishop Actions Provider
final bishopActionsProvider = StateNotifierProvider<BishopActionsNotifier, AsyncValue<void>>((ref) {
  return BishopActionsNotifier(ref);
});

class BishopActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  BishopActionsNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> addBishop(Bishop bishop) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = _ref.read(bishopRepositoryProvider);
      await repository.addBishop(bishop);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateBishop(Bishop bishop) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = _ref.read(bishopRepositoryProvider);
      await repository.updateBishop(bishop);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteBishop(String id) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = _ref.read(bishopRepositoryProvider);
      await repository.deleteBishop(id);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<String> uploadPhoto(String bishopId, String filePath) async {
    try {
      final repository = _ref.read(bishopRepositoryProvider);
      return await repository.uploadBishopPhoto(bishopId, filePath);
    } catch (error) {
      throw Exception('Failed to upload photo: $error');
    }
  }
}
