import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/medoq_button.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PaymentScreen({super.key, required this.data});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  String get method => widget.data['method'] as String? ?? 'wave';
  double get total => widget.data['total'] as double? ?? 0;
  String get medicationName =>
      widget.data['medicationName'] as String? ?? '';

  bool get isCash => method == 'cash';

  Color get methodColor {
    switch (method) {
      case 'wave':
        return const Color(0xFF1DA1F2);
      case 'orange':
        return const Color(0xFFFF6600);
      default:
        return MedoqColors.primaryNavy;
    }
  }

  String get methodLabel {
    switch (method) {
      case 'wave':
        return 'Wave';
      case 'orange':
        return 'Orange Money';
      default:
        return 'Paiement sur place';
    }
  }

  IconData get methodIcon {
    switch (method) {
      case 'wave':
        return Icons.waves_rounded;
      case 'orange':
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.storefront_rounded;
    }
  }

  void _pay() async {
    if (!isCash && _phoneController.text.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Numéro de téléphone invalide')),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.paymentSuccess, extra: widget.data);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      appBar: AppBar(
        title: const Text('Paiement'),
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
            // Payment method badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: methodColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: methodColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: methodColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(methodIcon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        methodLabel,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: methodColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${total.toInt()} FCFA',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (!isCash) ...[
              Text('Numéro $methodLabel',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                decoration: InputDecoration(
                  hintText: '77 000 00 00',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇸🇳', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          '+221',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                            width: 1, height: 20, color: MedoqColors.border),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (isCash) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MedoqColors.lightBlueBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_rounded,
                            color: MedoqColors.cyanAccent, size: 20),
                        const SizedBox(width: 8),
                        Text('Paiement sur place',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: MedoqColors.primaryNavy)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Votre médicament sera réservé pendant 2 heures. Présentez votre code de réservation à la pharmacie et réglez sur place.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MedoqColors.primaryNavy,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Order summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: MedoqColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Commande',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Text(
                    medicationName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Qty: ${widget.data['quantity'] ?? 1} — ${widget.data['pharmacyName'] ?? ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            MedoqButton(
              label: isCash
                  ? 'Confirmer la réservation'
                  : 'Payer ${total.toInt()} FCFA',
              onPressed: _pay,
              isLoading: _isLoading,
              backgroundColor: isCash ? null : methodColor,
              icon: isCash ? Icons.check_circle_rounded : methodIcon,
            ),

            const SizedBox(height: 16),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_rounded,
                      size: 14, color: MedoqColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    'Paiement sécurisé — SSL',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
