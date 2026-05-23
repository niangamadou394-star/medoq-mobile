import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/medoq_button.dart';

class _OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      title: 'Trouvez vos médicaments instantanément',
      subtitle:
          'Vérifiez la disponibilité en temps réel dans toutes les pharmacies près de chez vous à Dakar.',
      icon: Icons.search_rounded,
      color: MedoqColors.primaryNavy,
    ),
    _OnboardingPage(
      title: 'Réservez en un clic',
      subtitle:
          'Plus de déplacements inutiles. Réservez votre médicament et récupérez-le quand vous voulez.',
      icon: Icons.bookmark_added_rounded,
      color: MedoqColors.cyanAccent,
    ),
    _OnboardingPage(
      title: 'Payez avec Wave ou Orange Money',
      subtitle:
          'Réglez votre commande directement depuis l\'application. Simple, rapide, sécurisé.',
      icon: Icons.payments_rounded,
      color: MedoqColors.greenAvailable,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, top: 12),
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Text('Passer'),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              page.icon,
                              size: 80,
                              color: page.color,
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                height: 1.3,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: MedoqColors.textSecondary,
                                height: 1.6,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final isActive = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? MedoqColors.primaryNavy
                              : MedoqColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  MedoqButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    onPressed: _nextPage,
                    icon: _currentPage == _pages.length - 1
                        ? null
                        : Icons.arrow_forward_rounded,
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
