import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/medoq_button.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _resendCountdown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCountdown <= 0) {
        t.cancel();
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  String get _otpValue =>
      _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    } else if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isNotEmpty && index == 5) {
      _focusNodes[index].unfocus();
      _verifyOtp();
    }
  }

  void _verifyOtp() async {
    if (_otpValue.length != 6) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() => _isLoading = false);
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    _timer?.cancel();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              'Vérification',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: 'Code envoyé au ',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: MedoqColors.textSecondary),
                children: [
                  TextSpan(
                    text: widget.phone,
                    style: const TextStyle(
                      color: MedoqColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // OTP fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 48,
                  height: 56,
                  child: TextFormField(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: MedoqColors.primaryNavy,
                          fontWeight: FontWeight.w700,
                        ),
                    decoration: InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: MedoqColors.border, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: MedoqColors.primaryNavy, width: 2),
                      ),
                    ),
                    onChanged: (v) => _onDigitChanged(i, v),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            MedoqButton(
              label: 'Vérifier',
              onPressed: _otpValue.length == 6 ? _verifyOtp : null,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 24),

            Center(
              child: _resendCountdown > 0
                  ? Text(
                      'Renvoyer le code dans $_resendCountdown s',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: MedoqColors.textSecondary),
                    )
                  : TextButton(
                      onPressed: _startCountdown,
                      child: const Text('Renvoyer le code'),
                    ),
            ),

            const Spacer(),

            // Demo hint
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MedoqColors.lightBlueBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: MedoqColors.cyanAccent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Prototype : saisir n\'importe quel code à 6 chiffres',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MedoqColors.primaryNavy,
                          ),
                    ),
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
