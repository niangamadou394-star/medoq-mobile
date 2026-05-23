import '../models/reservation.dart';
import '../shared/utils/constants.dart';
import 'api_client.dart';

class CreateReservationRequest {
  final String pharmacyId;
  final String medicationId;
  final int quantity;
  final PaymentMethod paymentMethod;

  const CreateReservationRequest({
    required this.pharmacyId,
    required this.medicationId,
    required this.quantity,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'pharmacy_id': pharmacyId,
      'medication_id': medicationId,
      'quantity': quantity,
      'payment_method': paymentMethod.value,
    };
  }
}

class ReservationService {
  final ApiClient _client;

  ReservationService({ApiClient? client}) : _client = client ?? apiClient;

  Future<Reservation> createReservation(
      CreateReservationRequest request) async {
    final data = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.reservations,
      data: request.toJson(),
    );
    return Reservation.fromJson(data['reservation'] as Map<String, dynamic>);
  }

  Future<List<Reservation>> getMyReservations({
    ReservationStatus? status,
    int page = 1,
    int pageSize = AppConstants.pageSize,
  }) async {
    final data = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.reservations,
      queryParameters: {
        if (status != null) 'status': status.value,
        'page': page,
        'page_size': pageSize,
      },
    );

    final reservations = data['reservations'] as List<dynamic>? ?? [];
    return reservations
        .map((e) => Reservation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Reservation> getReservationById(String id) async {
    final data = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.reservationById(id),
    );
    return Reservation.fromJson(data);
  }

  Future<Reservation> cancelReservation(
    String id, {
    String? reason,
  }) async {
    final data = await _client.post<Map<String, dynamic>>(
      '${ApiEndpoints.reservationById(id)}/cancel',
      data: {
        if (reason != null) 'reason': reason,
      },
    );
    return Reservation.fromJson(data['reservation'] as Map<String, dynamic>);
  }
}
