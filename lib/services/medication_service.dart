import '../models/medication.dart';
import '../shared/utils/constants.dart';
import 'api_client.dart';

class MedicationService {
  final ApiClient _client;

  MedicationService({ApiClient? client}) : _client = client ?? apiClient;

  Future<List<MedicationSearchResult>> searchMedications({
    required String query,
    double? latitude,
    double? longitude,
    int radius = AppConstants.defaultRadius,
    StockStatus? stockFilter,
    int page = 1,
    int pageSize = AppConstants.pageSize,
  }) async {
    final data = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.medications,
      queryParameters: {
        'q': query,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lng': longitude,
        'radius': radius,
        if (stockFilter != null) 'stock_status': stockFilter.value,
        'page': page,
        'page_size': pageSize,
      },
    );

    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((e) =>
            MedicationSearchResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Medication> getMedicationById(String id) async {
    final data = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.medications}/$id',
    );
    return Medication.fromJson(data);
  }

  Future<List<Medication>> getPopularMedications({int limit = 10}) async {
    final data = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.popularMedications,
      queryParameters: {'limit': limit},
    );
    final results = data['medications'] as List<dynamic>? ?? [];
    return results
        .map((e) => Medication.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> getAutocomplete({
    required String query,
    int limit = 8,
  }) async {
    try {
      final data = await _client.get<Map<String, dynamic>>(
        '${ApiEndpoints.medications}/autocomplete',
        queryParameters: {'q': query, 'limit': limit},
      );
      final suggestions = data['suggestions'] as List<dynamic>? ?? [];
      return suggestions.map((e) => e as String).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final data = await _client.get<Map<String, dynamic>>(
        '${ApiEndpoints.medications}/categories',
      );
      final categories = data['categories'] as List<dynamic>? ?? [];
      return categories.map((e) => e as String).toList();
    } catch (_) {
      return _defaultCategories;
    }
  }

  static const List<String> _defaultCategories = [
    'Antibiotiques',
    'Antalgiques',
    'Anti-inflammatoires',
    'Antiparasitaires',
    'Vitamines',
    'Antihypertenseurs',
    'Diabète',
    'Dermatologie',
    'Ophtalmologie',
    'Pédiatrie',
  ];

  static const List<String> popularMedicationNames = [
    'Paracétamol',
    'Amoxicilline',
    'Ibuprofène',
    'Coartem',
    'Cotrimoxazole',
    'Métronidazole',
    'Oméprazole',
    'Amlodipine',
    'Metformine',
    'Vitamines B',
  ];
}
