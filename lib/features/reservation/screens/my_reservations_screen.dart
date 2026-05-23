import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../shared/data/mock_data.dart';

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});

  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<MockReservation> _getFiltered(String status) {
    return MockData.reservations
        .where((r) => r.status == status)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      appBar: AppBar(
        title: const Text('Mes réservations'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: MedoqColors.cyanAccent,
          tabs: const [
            Tab(text: 'Actives'),
            Tab(text: 'Terminées'),
            Tab(text: 'Expirées'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReservationList(
              reservations: _getFiltered('confirmed'),
              emptyMessage: 'Aucune réservation active'),
          _ReservationList(
              reservations: _getFiltered('completed'),
              emptyMessage: 'Aucune réservation terminée'),
          _ReservationList(
              reservations: _getFiltered('expired'),
              emptyMessage: 'Aucune réservation expirée'),
        ],
      ),
    );
  }
}

class _ReservationList extends StatelessWidget {
  final List<MockReservation> reservations;
  final String emptyMessage;

  const _ReservationList(
      {required this.reservations, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_rounded,
                size: 64, color: MedoqColors.border),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: MedoqColors.textSecondary,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, i) {
        return _ReservationCard(reservation: reservations[i]);
      },
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final MockReservation reservation;
  const _ReservationCard({required this.reservation});

  Color get _statusColor {
    switch (reservation.status) {
      case 'confirmed':
        return MedoqColors.primaryNavy;
      case 'completed':
        return MedoqColors.greenAvailable;
      case 'expired':
        return MedoqColors.redError;
      default:
        return MedoqColors.textSecondary;
    }
  }

  String get _statusLabel {
    switch (reservation.status) {
      case 'confirmed':
        return 'Confirmée';
      case 'completed':
        return 'Récupérée';
      case 'expired':
        return 'Expirée';
      default:
        return reservation.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MedoqColors.primaryNavy.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  reservation.medicationName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.local_pharmacy_rounded,
                  size: 14, color: MedoqColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  reservation.pharmacyName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.inventory_2_rounded,
                label: '${reservation.quantity} unité${reservation.quantity > 1 ? 's' : ''}',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.payments_rounded,
                label: '${reservation.totalPrice.toInt()} FCFA',
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    reservation.code,
                    style: TextStyle(
                      color: MedoqColors.primaryNavy,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    reservation.createdAt,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          if (reservation.status == 'confirmed') ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MedoqColors.lightBlueBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_rounded,
                      color: MedoqColors.primaryNavy, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Expire à ${reservation.expiresAt}',
                    style: TextStyle(
                      color: MedoqColors.primaryNavy,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: MedoqColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
