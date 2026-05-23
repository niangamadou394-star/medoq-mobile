import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/stock_badge.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: MedoqColors.primaryNavy,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 28,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour 👋',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Amadou',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          _HeaderIconButton(
                            icon: Icons.location_on_rounded,
                            label: 'Dakar',
                          ),
                          const SizedBox(width: 8),
                          _HeaderIconButton(
                            icon: Icons.notifications_none_rounded,
                            hasNotif: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Search bar
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.searchResults, extra: ''),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded,
                              color: MedoqColors.textSecondary, size: 22),
                          const SizedBox(width: 12),
                          Text(
                            'Rechercher un médicament...',
                            style: TextStyle(
                              color: MedoqColors.textSecondary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick pills: Popular searches
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recherches fréquentes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MockData.popularSearches.map((s) {
                      return GestureDetector(
                        onTap: () =>
                            context.push(AppRoutes.searchResults, extra: s),
                        child: Chip(
                          label: Text(s),
                          avatar: const Icon(Icons.search_rounded, size: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Nearby pharmacies section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pharmacies proches',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Voir tout'),
                  ),
                ],
              ),
            ),
          ),

          // Pharmacies list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final pharmacy = MockData.pharmacies[i];
                return _PharmacyCard(pharmacy: pharmacy);
              },
              childCount: MockData.pharmacies.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool hasNotif;

  const _HeaderIconButton({
    required this.icon,
    this.label,
    this.hasNotif = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              if (hasNotif)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: MedoqColors.orangeLimited,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  final MockPharmacy pharmacy;

  const _PharmacyCard({required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/pharmacy/${pharmacy.id}'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MedoqColors.primaryNavy.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: MedoqColors.lightBlueBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_pharmacy_rounded,
                  color: MedoqColors.primaryNavy,
                  size: 26,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pharmacy.name,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (pharmacy.isOnDuty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: MedoqColors.greenAvailable.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'De garde',
                            style: TextStyle(
                              color: MedoqColors.greenAvailable,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pharmacy.address,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: MedoqColors.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        '${pharmacy.distance} km',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.star_rounded,
                          size: 14, color: MedoqColors.orangeLimited),
                      const SizedBox(width: 3),
                      Text(
                        '${pharmacy.rating}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time_rounded,
                          size: 14, color: MedoqColors.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        pharmacy.openHours,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: MedoqColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
