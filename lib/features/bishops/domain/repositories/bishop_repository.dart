import '../entities/bishop.dart';
import '../entities/bishop_filter.dart';

abstract class BishopRepository {
  Stream<List<Bishop>> getBishops({BishopFilter? filter});
  Future<Bishop?> getBishopById(String id);
  Future<String> addBishop(Bishop bishop);
  Future<void> updateBishop(Bishop bishop);
  Future<void> deleteBishop(String id);
  Future<List<String>> getDioceses();
  Future<String> uploadBishopPhoto(String bishopId, String filePath);
  Future<void> deleteBishopPhoto(String photoUrl);
  Future<List<Bishop>> searchBishops(String query);
  Future<Map<String, int>> getBishopStatistics();
}
