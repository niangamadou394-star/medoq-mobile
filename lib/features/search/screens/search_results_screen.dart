import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/widgets/stock_badge.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _currentQuery = '';
  List<MockMedication> _medResults = [];
  List<MockPharmacy> _pharmResults = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.text = widget.query;
    _currentQuery = widget.query;
    _runSearch(widget.query);
  }

  void _runSearch(String q) {
    setState(() {
      _currentQuery = q;
      _medResults = MockData.searchMedications(q);
      _pharmResults = q.isEmpty
          ? MockData.pharmacies
          : MockData.pharmacies.where((p) {
              return p.name.toLowerCase().contains(q.toLowerCase()) ||
                  p.district.toLowerCase().contains(q.toLowerCase());
            }).toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      appBar: AppBar(
        backgroundColor: MedoqColors.background,
        foregroundColor: MedoqColors.textPrimary,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: widget.query.isEmpty,
          decoration: InputDecoration(
            hintText: 'Médicament, pharmacie...',
            prefixIcon:
                const Icon(Icons.search_rounded, color: MedoqColors.textSecondary),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _searchController.clear();
                      _runSearch('');
                    },
                  )
                : null,
            filled: true,
            fillColor: MedoqColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (v) {
            setState(() {});
            _runSearch(v);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: MedoqColors.primaryNavy,
          unselectedLabelColor: MedoqColors.textSecondary,
          indicatorColor: MedoqColors.primaryNavy,
          indicatorWeight: 2.5,
          tabs: [
            Tab(text: 'Médicaments (${_medResults.length})'),
            Tab(text: 'Pharmacies (${_pharmResults.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MedicationsTab(
            results: _medResults,
            query: _currentQuery,
          ),
          _PharmaciesTab(results: _pharmResults),
        ],
      ),
    );
  }
}

class _MedicationsTab extends StatelessWidget {
  final List<MockMedication> results;
  final String query;

  const _MedicationsTab({required this.results, required this.query});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return _EmptySearch(query: query);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final med = results[i];
        final pharmacies = MockData.searchPharmaciesForMedication(med.id);
        return GestureDetector(
          onTap: () {
            _showPharmaciesForMed(context, med, pharmacies);
          },
          child: Container(
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
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: MedoqColors.lightBlueBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.medication_rounded,
                        color: MedoqColors.primaryNavy, size: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              med.name,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          if (med.requiresPrescription)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: MedoqColors.orangeLimited.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: MedoqColors.orangeLimited
                                        .withOpacity(0.3)),
                              ),
                              child: const Text(
                                'Ordonnance',
                                style: TextStyle(
                                  color: MedoqColors.orangeLimited,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${med.form} — ${med.category}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.local_pharmacy_rounded,
                              size: 13, color: MedoqColors.primaryNavy),
                          const SizedBox(width: 4),
                          Text(
                            '${pharmacies.length} pharmacie${pharmacies.length > 1 ? 's' : ''} proche${pharmacies.length > 1 ? 's' : ''}',
                            style: TextStyle(
                              color: MedoqColors.primaryNavy,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'À partir de ${med.price.toInt()} FCFA',
                            style: TextStyle(
                              color: MedoqColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPharmaciesForMed(
      BuildContext context, MockMedication med, List<MockPharmacy> pharmacies) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MedicationPharmaciesSheet(
          medication: med, pharmacies: pharmacies),
    );
  }
}

class _MedicationPharmaciesSheet extends StatelessWidget {
  final MockMedication medication;
  final List<MockPharmacy> pharmacies;

  const _MedicationPharmaciesSheet(
      {required this.medication, required this.pharmacies});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(medication.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      '${pharmacies.length} pharmacie${pharmacies.length > 1 ? 's' : ''} avec ce médicament',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  itemCount: pharmacies.length,
                  itemBuilder: (context, i) {
                    final ph = pharmacies[i];
                    final stock = ph.stock.firstWhere(
                        (s) => s.medicationId == medication.id,
                        orElse: () => const MockStock(
                            medicationId: '',
                            quantity: 0,
                            price: 0,
                            status: 'unavailable'));
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/pharmacy/${ph.id}');
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: MedoqColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MedoqColors.border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ph.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${ph.distance} km — ${ph.district}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${stock.price.toInt()} FCFA',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                          color: MedoqColors.primaryNavy),
                                ),
                                const SizedBox(height: 4),
                                StockBadge(status: stock.status, small: true),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PharmaciesTab extends StatelessWidget {
  final List<MockPharmacy> results;

  const _PharmaciesTab({required this.results});

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return const _EmptySearch(query: '');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, i) {
        final p = results[i];
        return GestureDetector(
          onTap: () => context.push('/pharmacy/${p.id}'),
          child: Container(
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
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: MedoqColors.lightBlueBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.local_pharmacy_rounded,
                      color: MedoqColors.primaryNavy, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p.name,
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(height: 4),
                      Text(p.address,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: MedoqColors.textSecondary)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              size: 13, color: MedoqColors.textSecondary),
                          const SizedBox(width: 3),
                          Text('${p.distance} km',
                              style:
                                  Theme.of(context).textTheme.bodySmall),
                          const SizedBox(width: 10),
                          const Icon(Icons.star_rounded,
                              size: 13, color: MedoqColors.orangeLimited),
                          const SizedBox(width: 3),
                          Text('${p.rating}',
                              style:
                                  Theme.of(context).textTheme.bodySmall),
                          if (p.isOnDuty) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: MedoqColors.greenAvailable
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
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
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: MedoqColors.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64, color: MedoqColors.border),
            const SizedBox(height: 16),
            Text(
              query.isEmpty ? 'Commencez à taper...' : 'Aucun résultat pour "$query"',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: MedoqColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
