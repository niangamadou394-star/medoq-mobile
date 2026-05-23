import '../models/reservation.dart';
import '../shared/utils/constants.dart';
import 'api_client.dart';

class PaymentResult {
  final String paymentReference;
  final String? deepLinkUrl;
  final String? qrCode;
  final PaymentStatus status;

  const PaymentResult({
    required this.paymentReference,
    this.deepLinkUrl,
    this.qrCode,
    required this.status,
  });

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      paymentReference: json['payment_reference'] as String,
      deepLinkUrl: json['deep_link_url'] as String?,
      qrCode: json['qr_code'] as String?,
      status: PaymentStatus.fromString(json['status'] as String),
    );
  }
}

class PaymentService {
  final ApiClient _client;

  PaymentService({ApiClient? client}) : _client = client ?? apiClient;

  Future<PaymentResult> initiateWavePayment({
    required String reservationId,
    required double amount,
  }) async {
    final data = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.initiateWave,
      data: {
        'reservation_id': reservationId,
        'amount': amount,
        'currency': 'XOF',
        'return_url': 'medoq://payment/wave/callback',
        'cancel_url': 'medoq://payment/wave/cancel',
      },
    );
    return PaymentResult.fromJson(data);
  }

  Future<PaymentResult> initiateOrangeMoneyPayment({
    required String reservationId,
    required double amount,
    required String phoneNumber,
  }) async {
    final data = await _client.post<Map<String, dynamic>>(
      ApiEndpoints.initiateOrangeMoney,
      data: {
        'reservation_id': reservationId,
        'amount': amount,
        'currency': 'XOF',
        'phone_number': phoneNumber,
        'return_url': 'medoq://payment/orange-money/callback',
      },
    );
    return PaymentResult.fromJson(data);
  }

  Future<PaymentStatus> checkPaymentStatus(String paymentReference) async {
    final data = await _client.get<Map<String, dynamic>>(
      '/payments/$paymentReference/status',
    );
    return PaymentStatus.fromString(data['status'] as String);
  }
}
