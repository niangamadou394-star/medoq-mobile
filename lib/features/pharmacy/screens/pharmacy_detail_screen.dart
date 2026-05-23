import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/medoq_button.dart';
import '../../../shared/widgets/stock_badge.dart';

class PharmacyDetailScreen extends StatefulWidget {
  final String pharmacyId;
  const PharmacyDetailScreen({super.key, required this.pharmacyId});

  @override
  State<PharmacyDetailScreen> createState() => _PharmacyDetailScreenState();
}

class _PharmacyDetailScreenState extends State<PharmacyDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MockPharmacy pharmacy;
  bool _found = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final p = MockData.findPharmacy(widget.pharmacyId);
    if (p != null) {
      pharmacy = p;
      _found = true;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_found) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pharmacie')),
        body: const Center(child: Text('Pharmacie introuvable')),
      );
    }

    return Scaffold(
      backgroundColor: MedoqColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with gradient
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: MedoqColors.primaryNavy, size: 20),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share_rounded,
                      color: MedoqColors.primaryNavy, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [MedoqColors.primaryNavy, MedoqColors.cyanAccent],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.local_pharmacy_rounded,
                            color: MedoqColors.primaryNavy, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        pharmacy.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Info cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatCard(
                        icon: Icons.location_on_rounded,
                        label: 'Distance',
                        value: '${pharmacy.distance} km',
                        color: MedoqColors.cyanAccent,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        icon: Icons.star_rounded,
                        label: 'Note',
                        value: '${pharmacy.rating} (${pharmacy.reviewCount})',
                        color: MedoqColors.orangeLimited,
                      ),
                      const SizedBox(width: 10),
                      _StatCard(
                        icon: pharmacy.isOnDuty
                            ? Icons.nightlight_round
                            : Icons.access_time_rounded,
                        label: pharmacy.isOnDuty ? 'Garde' : 'Horaires',
                        value: pharmacy.isOnDuty ? '24h/24' : 'Voir',
                        color: pharmacy.isOnDuty
                            ? MedoqColors.greenAvailable
                            : MedoqColors.primaryNavy,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Address card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.place_rounded,
                            color: MedoqColors.primaryNavy),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pharmacy.address,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Text(pharmacy.district,
                                  style:
                                      Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.directions_rounded, size: 16),
                          label: const Text('Itinéraire'),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Phone card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.phone_rounded,
                            color: MedoqColors.primaryNavy),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(pharmacy.phone,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call_rounded, size: 16),
                          label: const Text('Appeler'),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: MedoqColors.primaryNavy,
                unselectedLabelColor: MedoqColors.textSecondary,
                indicatorColor: MedoqColors.primaryNavy,
                indicatorWeight: 2.5,
                tabs: [
                  Tab(text: 'Stock (${pharmacy.stock.length})'),
                  const Tab(text: 'Avis'),
                ],
              ),
            ),
          ),

          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _StockTab(pharmacy: pharmacy),
                _ReviewsTab(pharmacyName: pharmacy.name),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _StockTab extends StatelessWidget {
  final MockPharmacy pharmacy;
  const _StockTab({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pharmacy.stock.length,
      itemBuilder: (context, i) {
        final stock = pharmacy.stock[i];
        final med = MockData.findMedication(stock.medicationId);
        if (med == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: MedoqColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MedoqColors.lightBlueBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.medication_rounded,
                    color: MedoqColors.primaryNavy, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med.name,
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 3),
                    Text(
                      med.form,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        StockBadge(status: stock.status, small: true),
                        const Spacer(),
                        Text(
                          '${stock.price.toInt()} FCFA',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: MedoqColors.primaryNavy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              if (stock.status != 'unavailable')
                ElevatedButton(
                  onPressed: () {
                    context.push(
                      '/reservation/${pharmacy.id}/${med.id}',
                      extra: {
                        'pharmacyName': pharmacy.name,
                        'medicationName': med.name,
                        'price': stock.price,
                        'quantity': stock.quantity,
                        'status': stock.status,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  child: const Text('Réserver'),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final String pharmacyName;
  const _ReviewsTab({required this.pharmacyName});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      (
        'Fatou Diallo',
        5,
        'Excellent service ! Médicaments disponibles et personnel très sympa.',
        '2 jours'
      ),
      (
        'Moussa Ndiaye',
        4,
        'Bonne pharmacie, proche de chez moi. Parfois un peu d\'attente.',
        '1 semaine'
      ),
      (
        'Aminata Ba',
        5,
        'Toujours bien stockée. Je recommande vivement.',
        '2 semaines'
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, i) {
        final (name, rating, text, date) = reviews[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: MedoqColors.lightBlueBg,
                    child: Text(
                      name[0],
                      style: const TextStyle(
                          color: MedoqColors.primaryNavy,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: Theme.of(context).textTheme.titleSmall),
                        Row(
                          children: List.generate(
                              5,
                              (j) => Icon(
                                    j < rating
                                        ? Icons.star_rounded
                                        : Icons.star_outline_rounded,
                                    size: 14,
                                    color: MedoqColors.orangeLimited,
                                  )),
                        ),
                      ],
                    ),
                  ),
                  Text(date,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 8),
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      },
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _StickyTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: MedoqColors.background,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
