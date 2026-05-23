import 'medication.dart';

class Pharmacy {
  final String id;
  final String name;
  final String address;
  final String? phone;
  final double latitude;
  final double longitude;
  final double? distance;
  final double? rating;
  final int? reviewCount;
  final bool isOpen;
  final List<OpeningHour> openingHours;
  final String? imageUrl;
  final List<PharmacyMedication> medications;

  const Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    required this.latitude,
    required this.longitude,
    this.distance,
    this.rating,
    this.reviewCount,
    required this.isOpen,
    this.openingHours = const [],
    this.imageUrl,
    this.medications = const [],
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int?,
      isOpen: json['is_open'] as bool? ?? false,
      openingHours: (json['opening_hours'] as List<dynamic>?)
              ?.map((e) => OpeningHour.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      imageUrl: json['image_url'] as String?,
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => PharmacyMedication.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'rating': rating,
      'review_count': reviewCount,
      'is_open': isOpen,
      'opening_hours': openingHours.map((e) => e.toJson()).toList(),
      'image_url': imageUrl,
      'medications': medications.map((e) => e.toJson()).toList(),
    };
  }

  StockStatus get overallStockStatus {
    if (medications.isEmpty) return StockStatus.outOfStock;
    final hasAvailable =
        medications.any((m) => m.stockStatus == StockStatus.available);
    final hasLimited =
        medications.any((m) => m.stockStatus == StockStatus.limited);
    if (hasAvailable) return StockStatus.available;
    if (hasLimited) return StockStatus.limited;
    return StockStatus.outOfStock;
  }
}

class OpeningHour {
  final int dayOfWeek; // 1=Monday, 7=Sunday
  final String? openTime;
  final String? closeTime;
  final bool isClosed;

  const OpeningHour({
    required this.dayOfWeek,
    this.openTime,
    this.closeTime,
    required this.isClosed,
  });

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    return OpeningHour(
      dayOfWeek: json['day_of_week'] as int,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      isClosed: json['is_closed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_week': dayOfWeek,
      'open_time': openTime,
      'close_time': closeTime,
      'is_closed': isClosed,
    };
  }

  String get dayName {
    const days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    return days[dayOfWeek - 1];
  }
}

class PharmacyMedication {
  final String medicationId;
  final String medicationName;
  final StockStatus stockStatus;
  final int availableQuantity;
  final double price;

  const PharmacyMedication({
    required this.medicationId,
    required this.medicationName,
    required this.stockStatus,
    required this.availableQuantity,
    required this.price,
  });

  factory PharmacyMedication.fromJson(Map<String, dynamic> json) {
    return PharmacyMedication(
      medicationId: json['medication_id'] as String,
      medicationName: json['medication_name'] as String,
      stockStatus: StockStatus.fromString(json['stock_status'] as String),
      availableQuantity: json['available_quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medication_id': medicationId,
      'medication_name': medicationName,
      'stock_status': stockStatus.value,
      'available_quantity': availableQuantity,
      'price': price,
    };
  }
}

class PharmacyReview {
  final String id;
  final String userId;
  final String userName;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const PharmacyReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory PharmacyReview.fromJson(Map<String, dynamic> json) {
    return PharmacyReview(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
