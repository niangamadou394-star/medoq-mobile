import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/medoq_button.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PaymentSuccessScreen({super.key, required this.data});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get reservationCode {
    final now = DateTime.now();
    return 'MDQ-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond}';
  }

  @override
  Widget build(BuildContext context) {
    final pharmacy = widget.data['pharmacyName'] as String? ?? '';
    final medication = widget.data['medicationName'] as String? ?? '';
    final total = widget.data['total'] as double? ?? 0;
    final method = widget.data['method'] as String? ?? 'cash';
    final isCash = method == 'cash';

    return Scaffold(
      backgroundColor: MedoqColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Success animation
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: MedoqColors.greenAvailable,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text(
                      isCash ? 'Réservation confirmée !' : 'Paiement réussi !',
                      style: Theme.of(context).textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCash
                          ? 'Votre médicament est réservé pendant 2 heures'
                          : 'Votre paiement a été traité avec succès',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: MedoqColors.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Reservation code card
              FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: MedoqColors.primaryNavy.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text('Code de réservation',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Text(
                        reservationCode,
                        style: const TextStyle(
                          color: MedoqColors.primaryNavy,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 16),
                      _SuccessRow(label: 'Médicament', value: medication),
                      const SizedBox(height: 10),
                      _SuccessRow(label: 'Pharmacie', value: pharmacy),
                      if (!isCash) ...[
                        const SizedBox(height: 10),
                        _SuccessRow(
                            label: 'Montant payé',
                            value: '${total.toInt()} FCFA',
                            highlight: true),
                      ],
                      const SizedBox(height: 10),
                      _SuccessRow(
                        label: 'Valide jusqu\'à',
                        value: _expiryTime(),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Actions
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    MedoqButton(
                      label: 'Voir mes réservations',
                      onPressed: () => context.go(AppRoutes.home),
                      icon: Icons.receipt_long_rounded,
                    ),
                    const SizedBox(height: 12),
                    MedoqButton(
                      label: 'Retour à l\'accueil',
                      onPressed: () => context.go(AppRoutes.home),
                      isOutlined: true,
                      icon: Icons.home_rounded,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _expiryTime() {
    final expiry = DateTime.now().add(const Duration(hours: 2));
    return '${expiry.hour.toString().padLeft(2, '0')}:${expiry.minute.toString().padLeft(2, '0')} (dans 2h)';
  }
}

class _SuccessRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SuccessRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: MedoqColors.textSecondary)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
            color: highlight ? MedoqColors.primaryNavy : MedoqColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
