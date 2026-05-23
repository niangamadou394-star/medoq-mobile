class MockMedication {
  final String id;
  final String name;
  final String genericName;
  final String form;
  final String dosage;
  final String description;
  final double price;
  final bool requiresPrescription;
  final String category;

  const MockMedication({
    required this.id,
    required this.name,
    required this.genericName,
    required this.form,
    required this.dosage,
    required this.description,
    required this.price,
    required this.requiresPrescription,
    required this.category,
  });
}

class MockPharmacy {
  final String id;
  final String name;
  final String address;
  final String district;
  final double latitude;
  final double longitude;
  final double distance;
  final String phone;
  final bool isOnDuty;
  final String openHours;
  final double rating;
  final int reviewCount;
  final List<MockStock> stock;

  const MockPharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.phone,
    required this.isOnDuty,
    required this.openHours,
    required this.rating,
    required this.reviewCount,
    required this.stock,
  });
}

class MockStock {
  final String medicationId;
  final int quantity;
  final double price;
  final String status; // available, limited, unavailable

  const MockStock({
    required this.medicationId,
    required this.quantity,
    required this.price,
    required this.status,
  });
}

class MockReservation {
  final String id;
  final String pharmacyName;
  final String medicationName;
  final int quantity;
  final double totalPrice;
  final String status;
  final String createdAt;
  final String expiresAt;
  final String code;

  const MockReservation({
    required this.id,
    required this.pharmacyName,
    required this.medicationName,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    required this.code,
  });
}

class MockData {
  static const List<MockMedication> medications = [
    MockMedication(
      id: 'med1',
      name: 'Paracétamol 500mg',
      genericName: 'Paracétamol',
      form: 'Comprimé',
      dosage: '500mg',
      description: 'Analgésique et antipyrétique. Indiqué pour la douleur et la fièvre.',
      price: 500,
      requiresPrescription: false,
      category: 'Analgésiques',
    ),
    MockMedication(
      id: 'med2',
      name: 'Amoxicilline 500mg',
      genericName: 'Amoxicilline',
      form: 'Gélule',
      dosage: '500mg',
      description: 'Antibiotique de la famille des pénicillines. Sur ordonnance uniquement.',
      price: 1500,
      requiresPrescription: true,
      category: 'Antibiotiques',
    ),
    MockMedication(
      id: 'med3',
      name: 'Ibuprofène 400mg',
      genericName: 'Ibuprofène',
      form: 'Comprimé',
      dosage: '400mg',
      description: 'Anti-inflammatoire non stéroïdien (AINS). Douleur, fièvre, inflammation.',
      price: 750,
      requiresPrescription: false,
      category: 'Anti-inflammatoires',
    ),
    MockMedication(
      id: 'med4',
      name: 'Métronidazole 250mg',
      genericName: 'Métronidazole',
      form: 'Comprimé',
      dosage: '250mg',
      description: 'Antibiotique et antiparasitaire.',
      price: 800,
      requiresPrescription: true,
      category: 'Antibiotiques',
    ),
    MockMedication(
      id: 'med5',
      name: 'Artéméther/Luméfantrine',
      genericName: 'Coartem',
      form: 'Comprimé',
      dosage: '20/120mg',
      description: 'Antipaludéen. Traitement du paludisme non compliqué.',
      price: 3500,
      requiresPrescription: true,
      category: 'Antipaludéens',
    ),
    MockMedication(
      id: 'med6',
      name: 'Vitamine C 1000mg',
      genericName: 'Acide ascorbique',
      form: 'Comprimé effervescent',
      dosage: '1000mg',
      description: 'Complément alimentaire. Renforcement des défenses immunitaires.',
      price: 2000,
      requiresPrescription: false,
      category: 'Vitamines',
    ),
  ];

  static const List<MockPharmacy> pharmacies = [
    MockPharmacy(
      id: 'ph1',
      name: 'Pharmacie du Plateau',
      address: 'Avenue Léopold Sédar Senghor, Plateau',
      district: 'Plateau',
      latitude: 14.6945,
      longitude: -17.4474,
      distance: 0.8,
      phone: '+221 33 823 10 10',
      isOnDuty: true,
      openHours: 'Ouverte 24h/24',
      rating: 4.7,
      reviewCount: 128,
      stock: [
        MockStock(medicationId: 'med1', quantity: 50, price: 500, status: 'available'),
        MockStock(medicationId: 'med2', quantity: 15, price: 1500, status: 'available'),
        MockStock(medicationId: 'med3', quantity: 30, price: 750, status: 'available'),
        MockStock(medicationId: 'med5', quantity: 3, price: 3500, status: 'limited'),
        MockStock(medicationId: 'med6', quantity: 20, price: 2000, status: 'available'),
      ],
    ),
    MockPharmacy(
      id: 'ph2',
      name: 'Pharmacie Mermoz',
      address: 'Route de la Corniche, Mermoz',
      district: 'Mermoz',
      latitude: 14.7123,
      longitude: -17.4651,
      distance: 2.1,
      phone: '+221 33 860 22 33',
      isOnDuty: false,
      openHours: 'Lun–Sam 8h–21h',
      rating: 4.4,
      reviewCount: 86,
      stock: [
        MockStock(medicationId: 'med1', quantity: 80, price: 480, status: 'available'),
        MockStock(medicationId: 'med2', quantity: 0, price: 1500, status: 'unavailable'),
        MockStock(medicationId: 'med3', quantity: 5, price: 750, status: 'limited'),
        MockStock(medicationId: 'med4', quantity: 25, price: 800, status: 'available'),
        MockStock(medicationId: 'med6', quantity: 10, price: 2000, status: 'available'),
      ],
    ),
    MockPharmacy(
      id: 'ph3',
      name: 'Pharmacie Fann',
      address: 'Avenue Cheikh Anta Diop, Fann',
      district: 'Fann',
      latitude: 14.6921,
      longitude: -17.4716,
      distance: 3.4,
      phone: '+221 33 825 44 55',
      isOnDuty: false,
      openHours: 'Lun–Dim 8h–22h',
      rating: 4.6,
      reviewCount: 203,
      stock: [
        MockStock(medicationId: 'med1', quantity: 100, price: 500, status: 'available'),
        MockStock(medicationId: 'med2', quantity: 20, price: 1400, status: 'available'),
        MockStock(medicationId: 'med3', quantity: 45, price: 730, status: 'available'),
        MockStock(medicationId: 'med4', quantity: 12, price: 800, status: 'available'),
        MockStock(medicationId: 'med5', quantity: 8, price: 3400, status: 'available'),
        MockStock(medicationId: 'med6', quantity: 0, price: 2000, status: 'unavailable'),
      ],
    ),
    MockPharmacy(
      id: 'ph4',
      name: 'Pharmacie Point E',
      address: 'Rue 10 x Rue 9, Point E',
      district: 'Point E',
      latitude: 14.7034,
      longitude: -17.4589,
      distance: 4.2,
      phone: '+221 33 824 77 88',
      isOnDuty: false,
      openHours: 'Lun–Sam 7h30–22h',
      rating: 4.3,
      reviewCount: 64,
      stock: [
        MockStock(medicationId: 'med1', quantity: 2, price: 500, status: 'limited'),
        MockStock(medicationId: 'med3', quantity: 60, price: 750, status: 'available'),
        MockStock(medicationId: 'med5', quantity: 15, price: 3500, status: 'available'),
        MockStock(medicationId: 'med6', quantity: 30, price: 1950, status: 'available'),
      ],
    ),
  ];

  static const List<MockReservation> reservations = [
    MockReservation(
      id: 'res1',
      pharmacyName: 'Pharmacie du Plateau',
      medicationName: 'Paracétamol 500mg',
      quantity: 2,
      totalPrice: 1000,
      status: 'confirmed',
      createdAt: '10 Apr 2026, 14:30',
      expiresAt: '10 Apr 2026, 16:30',
      code: 'MDQ-20264101',
    ),
    MockReservation(
      id: 'res2',
      pharmacyName: 'Pharmacie Fann',
      medicationName: 'Amoxicilline 500mg',
      quantity: 1,
      totalPrice: 1400,
      status: 'completed',
      createdAt: '08 Apr 2026, 10:15',
      expiresAt: '08 Apr 2026, 12:15',
      code: 'MDQ-20264080',
    ),
    MockReservation(
      id: 'res3',
      pharmacyName: 'Pharmacie Mermoz',
      medicationName: 'Vitamine C 1000mg',
      quantity: 3,
      totalPrice: 6000,
      status: 'expired',
      createdAt: '05 Apr 2026, 09:00',
      expiresAt: '05 Apr 2026, 11:00',
      code: 'MDQ-20264050',
    ),
  ];

  static List<MockPharmacy> searchPharmaciesForMedication(String medicationId) {
    return pharmacies.where((p) {
      return p.stock.any((s) => s.medicationId == medicationId && s.status != 'unavailable');
    }).toList();
  }

  static MockMedication? findMedication(String id) {
    try {
      return medications.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  static MockPharmacy? findPharmacy(String id) {
    try {
      return pharmacies.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<MockMedication> searchMedications(String query) {
    if (query.isEmpty) return medications;
    final q = query.toLowerCase();
    return medications.where((m) =>
      m.name.toLowerCase().contains(q) ||
      m.genericName.toLowerCase().contains(q) ||
      m.category.toLowerCase().contains(q)
    ).toList();
  }

  static const List<String> popularSearches = [
    'Paracétamol',
    'Amoxicilline',
    'Ibuprofène',
    'Coartem',
    'Vitamine C',
    'Métronidazole',
  ];
}
