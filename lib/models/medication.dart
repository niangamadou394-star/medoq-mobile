class Medication {
  final String id;
  final String name;
  final String genericName;
  final String? description;
  final String category;
  final String? imageUrl;
  final bool requiresPrescription;
  final double? price;
  final StockStatus? stockStatus;
  final int? availableQuantity;

  const Medication({
    required this.id,
    required this.name,
    required this.genericName,
    this.description,
    required this.category,
    this.imageUrl,
    required this.requiresPrescription,
    this.price,
    this.stockStatus,
    this.availableQuantity,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      genericName: json['generic_name'] as String? ?? json['name'] as String,
      description: json['description'] as String?,
      category: json['category'] as String? ?? 'Général',
      imageUrl: json['image_url'] as String?,
      requiresPrescription: json['requires_prescription'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble(),
      stockStatus: json['stock_status'] != null
          ? StockStatus.fromString(json['stock_status'] as String)
          : null,
      availableQuantity: json['available_quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'requires_prescription': requiresPrescription,
      'price': price,
      'stock_status': stockStatus?.value,
      'available_quantity': availableQuantity,
    };
  }
}

enum StockStatus {
  available,
  limited,
  outOfStock;

  static StockStatus fromString(String value) {
    switch (value) {
      case 'available':
        return StockStatus.available;
      case 'limited':
        return StockStatus.limited;
      case 'out_of_stock':
        return StockStatus.outOfStock;
      default:
        return StockStatus.outOfStock;
    }
  }

  String get value {
    switch (this) {
      case StockStatus.available:
        return 'available';
      case StockStatus.limited:
        return 'limited';
      case StockStatus.outOfStock:
        return 'out_of_stock';
    }
  }

  String get label {
    switch (this) {
      case StockStatus.available:
        return 'Disponible';
      case StockStatus.limited:
        return 'Stock limité';
      case StockStatus.outOfStock:
        return 'Rupture de stock';
    }
  }
}

class MedicationSearchResult {
  final Medication medication;
  final List<PharmacyStock> pharmacyStocks;

  const MedicationSearchResult({
    required this.medication,
    required this.pharmacyStocks,
  });

  factory MedicationSearchResult.fromJson(Map<String, dynamic> json) {
    return MedicationSearchResult(
      medication: Medication.fromJson(json['medication'] as Map<String, dynamic>),
      pharmacyStocks: (json['pharmacy_stocks'] as List<dynamic>?)
              ?.map((e) => PharmacyStock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PharmacyStock {
  final String pharmacyId;
  final String pharmacyName;
  final double distance;
  final StockStatus stockStatus;
  final int availableQuantity;
  final double price;

  const PharmacyStock({
    required this.pharmacyId,
    required this.pharmacyName,
    required this.distance,
    required this.stockStatus,
    required this.availableQuantity,
    required this.price,
  });

  factory PharmacyStock.fromJson(Map<String, dynamic> json) {
    return PharmacyStock(
      pharmacyId: json['pharmacy_id'] as String,
      pharmacyName: json['pharmacy_name'] as String,
      distance: (json['distance'] as num).toDouble(),
      stockStatus: StockStatus.fromString(json['stock_status'] as String),
      availableQuantity: json['available_quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}
