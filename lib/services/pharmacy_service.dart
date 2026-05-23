import '../models/pharmacy.dart';
import '../shared/utils/constants.dart';
import 'api_client.dart';

class PharmacyService {
  final ApiClient _client;

  PharmacyService({ApiClient? client}) : _client = client ?? apiClient;

  Future<List<Pharmacy>> getNearbyPharmacies({
    required double latitude,
    required double longitude,
    int radius = AppConstants.defaultRadius,
    int limit = 10,
  }) async {
    final data = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.nearbyPharmacies,
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
        'limit': limit,
      },
    );

    final pharmacies = data['pharmacies'] as List<dynamic>? ?? [];
    return pharmacies
        .map((e) => Pharmacy.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Pharmacy> getPharmacyById(String id) async {
    final data = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.pharmacies}/$id',
    );
    return Pharmacy.fromJson(data);
  }

  Future<List<PharmacyReview>> getPharmacyReviews(
    String pharmacyId, {
    int page = 1,
    int pageSize = AppConstants.pageSize,
  }) async {
    final data = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.pharmacies}/$pharmacyId/reviews',
      queryParameters: {'page': page, 'page_size': pageSize},
    );

    final reviews = data['reviews'] as List<dynamic>? ?? [];
    return reviews
        .map((e) => PharmacyReview.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Pharmacy>> searchPharmacies({
    String? query,
    required double latitude,
    required double longitude,
    int radius = AppConstants.defaultRadius,
    String? medicationId,
    bool? inStockOnly,
  }) async {
    final data = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.pharmacies,
      queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
        if (medicationId != null) 'medication_id': medicationId,
        if (inStockOnly == true) 'in_stock': true,
      },
    );

    final pharmacies = data['pharmacies'] as List<dynamic>? ?? [];
    return pharmacies
        .map((e) => Pharmacy.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
