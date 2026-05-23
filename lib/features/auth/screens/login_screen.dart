import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/medoq_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() => _isLoading = false);
      context.push(AppRoutes.otp, extra: '+221 ${_phoneController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Logo
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: MedoqColors.primaryNavy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Medoq',
                      style: TextStyle(
                        color: MedoqColors.primaryNavy,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                Text(
                  'Connexion',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Entrez votre numéro de téléphone pour recevoir un code de vérification.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: MedoqColors.textSecondary,
                      ),
                ),

                const SizedBox(height: 40),

                // Phone field
                Text(
                  'Numéro de téléphone',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 8),
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
                            width: 1,
                            height: 20,
                            color: MedoqColors.border,
                          ),
                        ],
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Numéro requis';
                    if (v.length != 9) return 'Numéro invalide (9 chiffres)';
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                MedoqButton(
                  label: 'Recevoir le code',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'ou',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                // Demo shortcut (prototype only)
                MedoqButton(
                  label: 'Accès démo (prototype)',
                  onPressed: () => context.go(AppRoutes.home),
                  isOutlined: true,
                  icon: Icons.rocket_launch_rounded,
                ),

                const SizedBox(height: 40),

                // Terms
                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'En continuant, vous acceptez nos ',
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Conditions d\'utilisation',
                          style: TextStyle(
                            color: MedoqColors.primaryNavy,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                          ),
                        ),
                        const TextSpan(text: ' et notre '),
                        TextSpan(
                          text: 'Politique de confidentialité',
                          style: TextStyle(
                            color: MedoqColors.primaryNavy,
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
