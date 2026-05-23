import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/medoq_button.dart';

class ReservationScreen extends StatefulWidget {
  final String pharmacyId;
  final String medicationId;
  final Map<String, dynamic> extra;

  const ReservationScreen({
    super.key,
    required this.pharmacyId,
    required this.medicationId,
    required this.extra,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int _quantity = 1;
  bool _hasPrescription = false;
  String _pickupTime = 'Dans 1h';

  final List<String> _pickupOptions = [
    'Dans 1h',
    'Dans 2h',
    'Aujourd\'hui après 18h',
    'Demain matin',
  ];

  double get _unitPrice =>
      (widget.extra['price'] as double?) ?? 0.0;
  double get _subtotal => _unitPrice * _quantity;
  double get _commission => _subtotal * 0.02;
  double get _total => _subtotal + _commission;

  String get _pharmacyName =>
      widget.extra['pharmacyName'] as String? ?? 'Pharmacie';
  String get _medicationName =>
      widget.extra['medicationName'] as String? ?? 'Médicament';
  int get _availableQty =>
      (widget.extra['quantity'] as int?) ?? 10;
  bool get _isLimited =>
      (widget.extra['status'] as String?) == 'limited';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      appBar: AppBar(
        title: const Text('Réserver'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: MedoqColors.primaryNavy.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: MedoqColors.lightBlueBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.medication_rounded,
                            color: MedoqColors.primaryNavy, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_medicationName,
                                style:
                                    Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.local_pharmacy_rounded,
                                    size: 14,
                                    color: MedoqColors.textSecondary),
                                const SizedBox(width: 4),
                                Text(_pharmacyName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_isLimited) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MedoqColors.orangeLimited.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color:
                                MedoqColors.orangeLimited.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: MedoqColors.orangeLimited, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Stock limité — seulement $_availableQty unité${_availableQty > 1 ? 's' : ''} disponible${_availableQty > 1 ? 's' : ''}',
                              style: TextStyle(
                                color: MedoqColors.orangeLimited,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quantity selector
            Text('Quantité',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: MedoqColors.border),
              ),
              child: Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove_rounded,
                    onTap: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '$_quantity',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add_rounded,
                    onTap: _quantity < _availableQty
                        ? () => setState(() => _quantity++)
                        : null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Pickup time
            Text('Heure de retrait',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _pickupOptions.map((opt) {
                final selected = _pickupTime == opt;
                return GestureDetector(
                  onTap: () => setState(() => _pickupTime = opt),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? MedoqColors.primaryNavy
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? MedoqColors.primaryNavy
                            : MedoqColors.border,
                      ),
                    ),
                    child: Text(
                      opt,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : MedoqColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Prescription
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: MedoqColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_rounded,
                      color: MedoqColors.primaryNavy),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ordonnance médicale',
                            style:
                                Theme.of(context).textTheme.titleSmall),
                        Text(
                          'Ce médicament peut nécessiter une ordonnance',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _hasPrescription,
                    onChanged: (v) =>
                        setState(() => _hasPrescription = v),
                    activeColor: MedoqColors.primaryNavy,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Price breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MedoqColors.lightBlueBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: MedoqColors.cyanAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  _PriceRow(
                      label: '$_medicationName × $_quantity',
                      value: '${_subtotal.toInt()} FCFA'),
                  const SizedBox(height: 8),
                  _PriceRow(
                      label: 'Frais de service (2%)',
                      value: '${_commission.toInt()} FCFA',
                      isLight: true),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 1),
                  ),
                  _PriceRow(
                    label: 'Total',
                    value: '${_total.toInt()} FCFA',
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            MedoqButton(
              label: 'Confirmer la réservation',
              onPressed: () {
                context.push(AppRoutes.reservationConfirm, extra: {
                  'pharmacyName': _pharmacyName,
                  'medicationName': _medicationName,
                  'quantity': _quantity,
                  'unitPrice': _unitPrice,
                  'total': _total,
                  'pickupTime': _pickupTime,
                });
              },
              icon: Icons.bookmark_add_rounded,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: enabled ? MedoqColors.lightBlueBg : MedoqColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: enabled ? MedoqColors.primaryNavy : MedoqColors.border,
          size: 22,
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLight;
  final bool isBold;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isLight = false,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isLight ? MedoqColors.textSecondary : MedoqColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            color: isBold ? MedoqColors.primaryNavy : MedoqColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
