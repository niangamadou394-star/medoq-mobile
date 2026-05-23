import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/medoq_button.dart';

class ReservationConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const ReservationConfirmationScreen({super.key, required this.data});

  String get pharmacyName => data['pharmacyName'] as String? ?? '';
  String get medicationName => data['medicationName'] as String? ?? '';
  int get quantity => data['quantity'] as int? ?? 1;
  double get unitPrice => data['unitPrice'] as double? ?? 0;
  double get total => data['total'] as double? ?? 0;
  String get pickupTime => data['pickupTime'] as String? ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      appBar: AppBar(
        title: const Text('Confirmation'),
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
            // Order recap
            Text('Récapitulatif',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RecapRow(
                      icon: Icons.medication_rounded,
                      label: 'Médicament',
                      value: medicationName),
                  const Divider(height: 24),
                  _RecapRow(
                      icon: Icons.local_pharmacy_rounded,
                      label: 'Pharmacie',
                      value: pharmacyName),
                  const Divider(height: 24),
                  _RecapRow(
                      icon: Icons.inventory_2_rounded,
                      label: 'Quantité',
                      value: '$quantity unité${quantity > 1 ? 's' : ''}'),
                  const Divider(height: 24),
                  _RecapRow(
                      icon: Icons.access_time_rounded,
                      label: 'Retrait',
                      value: pickupTime),
                  const Divider(height: 24),
                  _RecapRow(
                      icon: Icons.payments_rounded,
                      label: 'Total',
                      value: '${total.toInt()} FCFA',
                      highlight: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MedoqColors.lightBlueBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: MedoqColors.cyanAccent.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_rounded,
                          color: MedoqColors.cyanAccent, size: 18),
                      const SizedBox(width: 8),
                      Text('Comment ça fonctionne ?',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: MedoqColors.primaryNavy)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoStep(
                      step: '1',
                      text: 'Payez maintenant via Wave ou Orange Money'),
                  const SizedBox(height: 8),
                  _InfoStep(
                      step: '2',
                      text:
                          'Votre réservation est confirmée (valable 2 heures)'),
                  const SizedBox(height: 8),
                  _InfoStep(
                      step: '3',
                      text:
                          'Récupérez votre médicament en présentant votre code'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Pay buttons
            MedoqButton(
              label: 'Payer avec Wave',
              onPressed: () {
                context.push(AppRoutes.payment, extra: {
                  ...data,
                  'method': 'wave',
                });
              },
              backgroundColor: const Color(0xFF1DA1F2),
              icon: Icons.waves_rounded,
            ),
            const SizedBox(height: 12),
            MedoqButton(
              label: 'Payer avec Orange Money',
              onPressed: () {
                context.push(AppRoutes.payment, extra: {
                  ...data,
                  'method': 'orange',
                });
              },
              backgroundColor: const Color(0xFFFF6600),
              icon: Icons.account_balance_wallet_rounded,
            ),
            const SizedBox(height: 12),
            MedoqButton(
              label: 'Payer sur place',
              onPressed: () {
                context.push(AppRoutes.payment, extra: {
                  ...data,
                  'method': 'cash',
                });
              },
              isOutlined: true,
              icon: Icons.storefront_rounded,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _RecapRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _RecapRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon,
            color: highlight
                ? MedoqColors.primaryNavy
                : MedoqColors.textSecondary,
            size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                value,
                style: highlight
                    ? Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: MedoqColors.primaryNavy,
                          fontWeight: FontWeight.w700,
                        )
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoStep extends StatelessWidget {
  final String step;
  final String text;
  const _InfoStep({required this.step, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: MedoqColors.primaryNavy,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: MedoqColors.primaryNavy,
                  height: 1.5,
                ),
          ),
        ),
      ],
    );
  }
}
