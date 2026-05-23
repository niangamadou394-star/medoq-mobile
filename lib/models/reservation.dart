class Reservation {
  final String id;
  final String referenceNumber;
  final String patientId;
  final String pharmacyId;
  final String pharmacyName;
  final String pharmacyAddress;
  final double pharmacyLatitude;
  final double pharmacyLongitude;
  final String medicationId;
  final String medicationName;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final double commission;
  final ReservationStatus status;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final String? paymentReference;

  const Reservation({
    required this.id,
    required this.referenceNumber,
    required this.patientId,
    required this.pharmacyId,
    required this.pharmacyName,
    required this.pharmacyAddress,
    required this.pharmacyLatitude,
    required this.pharmacyLongitude,
    required this.medicationId,
    required this.medicationName,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.commission,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.expiresAt,
    this.confirmedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.paymentReference,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      referenceNumber: json['reference_number'] as String,
      patientId: json['patient_id'] as String,
      pharmacyId: json['pharmacy_id'] as String,
      pharmacyName: json['pharmacy_name'] as String,
      pharmacyAddress: json['pharmacy_address'] as String,
      pharmacyLatitude: (json['pharmacy_latitude'] as num).toDouble(),
      pharmacyLongitude: (json['pharmacy_longitude'] as num).toDouble(),
      medicationId: json['medication_id'] as String,
      medicationName: json['medication_name'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      commission: (json['commission'] as num).toDouble(),
      status: ReservationStatus.fromString(json['status'] as String),
      paymentMethod: PaymentMethod.fromString(json['payment_method'] as String),
      paymentStatus: PaymentStatus.fromString(json['payment_status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      cancellationReason: json['cancellation_reason'] as String?,
      paymentReference: json['payment_reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference_number': referenceNumber,
      'patient_id': patientId,
      'pharmacy_id': pharmacyId,
      'pharmacy_name': pharmacyName,
      'pharmacy_address': pharmacyAddress,
      'pharmacy_latitude': pharmacyLatitude,
      'pharmacy_longitude': pharmacyLongitude,
      'medication_id': medicationId,
      'medication_name': medicationName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_amount': totalAmount,
      'commission': commission,
      'status': status.value,
      'payment_method': paymentMethod.value,
      'payment_status': paymentStatus.value,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancellation_reason': cancellationReason,
      'payment_reference': paymentReference,
    };
  }

  bool get isActive =>
      status == ReservationStatus.pending ||
      status == ReservationStatus.confirmed;

  bool get isCancellable =>
      status == ReservationStatus.pending ||
      status == ReservationStatus.confirmed;

  Duration? get timeRemaining {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

enum ReservationStatus {
  pending,
  confirmed,
  completed,
  cancelled,
  expired;

  static ReservationStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return ReservationStatus.pending;
      case 'confirmed':
        return ReservationStatus.confirmed;
      case 'completed':
        return ReservationStatus.completed;
      case 'cancelled':
        return ReservationStatus.cancelled;
      case 'expired':
        return ReservationStatus.expired;
      default:
        return ReservationStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case ReservationStatus.pending:
        return 'pending';
      case ReservationStatus.confirmed:
        return 'confirmed';
      case ReservationStatus.completed:
        return 'completed';
      case ReservationStatus.cancelled:
        return 'cancelled';
      case ReservationStatus.expired:
        return 'expired';
    }
  }

  String get label {
    switch (this) {
      case ReservationStatus.pending:
        return 'En attente';
      case ReservationStatus.confirmed:
        return 'Confirmée';
      case ReservationStatus.completed:
        return 'Récupérée';
      case ReservationStatus.cancelled:
        return 'Annulée';
      case ReservationStatus.expired:
        return 'Expirée';
    }
  }
}

enum PaymentMethod {
  wave,
  orangeMoney;

  static PaymentMethod fromString(String value) {
    switch (value) {
      case 'wave':
        return PaymentMethod.wave;
      case 'orange_money':
        return PaymentMethod.orangeMoney;
      default:
        return PaymentMethod.wave;
    }
  }

  String get value {
    switch (this) {
      case PaymentMethod.wave:
        return 'wave';
      case PaymentMethod.orangeMoney:
        return 'orange_money';
    }
  }

  String get label {
    switch (this) {
      case PaymentMethod.wave:
        return 'Wave';
      case PaymentMethod.orangeMoney:
        return 'Orange Money';
    }
  }
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded;

  static PaymentStatus fromString(String value) {
    switch (value) {
      case 'pending':
        return PaymentStatus.pending;
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case PaymentStatus.pending:
        return 'pending';
      case PaymentStatus.paid:
        return 'paid';
      case PaymentStatus.failed:
        return 'failed';
      case PaymentStatus.refunded:
        return 'refunded';
    }
  }

  String get label {
    switch (this) {
      case PaymentStatus.pending:
        return 'En attente';
      case PaymentStatus.paid:
        return 'Payé';
      case PaymentStatus.failed:
        return 'Échec';
      case PaymentStatus.refunded:
        return 'Remboursé';
    }
  }
}
