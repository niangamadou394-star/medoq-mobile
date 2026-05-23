import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../shared/data/mock_data.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      appBar: AppBar(
        title: const Text('Carte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Placeholder map
          Container(
            color: const Color(0xFFE8F0E4),
            child: CustomPaint(
              painter: _MapGridPainter(),
              child: const SizedBox.expand(),
            ),
          ),

          // Map pins
          ...MockData.pharmacies.map((p) {
            // Simulated positions
            final positions = [
              const Offset(0.45, 0.42),
              const Offset(0.28, 0.3),
              const Offset(0.62, 0.55),
              const Offset(0.35, 0.65),
            ];
            final index = MockData.pharmacies.indexOf(p);
            final pos = positions[index % positions.length];

            return Positioned(
              left: MediaQuery.of(context).size.width * pos.dx - 20,
              top: MediaQuery.of(context).size.height * pos.dy - 40,
              child: _MapPin(pharmacy: p),
            );
          }).toList(),

          // Bottom info card
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${MockData.pharmacies.length} pharmacies trouvées',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dans un rayon de 5 km autour de vous',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: MedoqColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final MockPharmacy pharmacy;
  const _MapPin({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _PharmacyBottomSheet(pharmacy: pharmacy),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: pharmacy.isOnDuty
                  ? MedoqColors.greenAvailable
                  : MedoqColors.primaryNavy,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              pharmacy.name.split(' ').last,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CustomPaint(
            painter: _PinTailPainter(
              color: pharmacy.isOnDuty
                  ? MedoqColors.greenAvailable
                  : MedoqColors.primaryNavy,
            ),
            child: const SizedBox(width: 10, height: 8),
          ),
        ],
      ),
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PharmacyBottomSheet extends StatelessWidget {
  final MockPharmacy pharmacy;
  const _PharmacyBottomSheet({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: MedoqColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(pharmacy.name,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(pharmacy.address,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: MedoqColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 16, color: MedoqColors.primaryNavy),
              const SizedBox(width: 4),
              Text('${pharmacy.distance} km',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_rounded,
                  size: 16, color: MedoqColors.primaryNavy),
              const SizedBox(width: 4),
              Text(pharmacy.openHours,
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/pharmacy/${pharmacy.id}');
            },
            child: const Text('Voir la pharmacie'),
          ),
        ],
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;

    const step = 50.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw some "roads"
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.48),
        roadPaint);
    canvas.drawLine(
        Offset(size.width * 0.35, 0),
        Offset(size.width * 0.38, size.height),
        roadPaint);
    canvas.drawLine(
        Offset(0, size.height * 0.65),
        Offset(size.width, size.height * 0.7),
        roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
