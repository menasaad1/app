import 'package:cloud_firestore/cloud_firestore.dart';

class BishopFilter {
  final String? searchQuery;
  final String? diocese;
  final DateTime? startDate;
  final DateTime? endDate;
  final BishopSortBy sortBy;
  final bool ascending;
  final int? limit;

  const BishopFilter({
    this.searchQuery,
    this.diocese,
    this.startDate,
    this.endDate,
    this.sortBy = BishopSortBy.name,
    this.ascending = true,
    this.limit,
  });

  BishopFilter copyWith({
    String? searchQuery,
    String? diocese,
    DateTime? startDate,
    DateTime? endDate,
    BishopSortBy? sortBy,
    bool? ascending,
    int? limit,
  }) {
    return BishopFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      diocese: diocese ?? this.diocese,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
      limit: limit ?? this.limit,
    );
  }

  Query<Map<String, dynamic>> applyToQuery(Query<Map<String, dynamic>> query) {
    Query<Map<String, dynamic>> filteredQuery = query;

    // Apply diocese filter
    if (diocese != null && diocese!.isNotEmpty) {
      filteredQuery = filteredQuery.where('diocese', isEqualTo: diocese);
    }

    // Apply date range filter
    if (startDate != null) {
      filteredQuery = filteredQuery.where('ordinationDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!));
    }
    if (endDate != null) {
      filteredQuery = filteredQuery.where('ordinationDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate!));
    }

    // Apply sorting
    switch (sortBy) {
      case BishopSortBy.name:
        filteredQuery = filteredQuery.orderBy('name', descending: !ascending);
        break;
      case BishopSortBy.ordinationDate:
        filteredQuery = filteredQuery.orderBy('ordinationDate', descending: !ascending);
        break;
      case BishopSortBy.diocese:
        filteredQuery = filteredQuery.orderBy('diocese', descending: !ascending);
        break;
      case BishopSortBy.createdAt:
        filteredQuery = filteredQuery.orderBy('createdAt', descending: !ascending);
        break;
    }

    // Apply limit
    if (limit != null) {
      filteredQuery = filteredQuery.limit(limit!);
    }

    return filteredQuery;
  }

  List<Bishop> applySearchFilter(List<Bishop> bishops) {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return bishops;
    }

    final query = searchQuery!.toLowerCase();
    return bishops.where((bishop) {
      return bishop.name.toLowerCase().contains(query) ||
             bishop.title.toLowerCase().contains(query) ||
             bishop.diocese.toLowerCase().contains(query) ||
             (bishop.biography?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BishopFilter &&
           other.searchQuery == searchQuery &&
           other.diocese == diocese &&
           other.startDate == startDate &&
           other.endDate == endDate &&
           other.sortBy == sortBy &&
           other.ascending == ascending &&
           other.limit == limit;
  }

  @override
  int get hashCode {
    return Object.hash(
      searchQuery,
      diocese,
      startDate,
      endDate,
      sortBy,
      ascending,
      limit,
    );
  }
}

enum BishopSortBy {
  name,
  ordinationDate,
  diocese,
  createdAt,
}
