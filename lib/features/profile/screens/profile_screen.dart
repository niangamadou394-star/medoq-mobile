import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../app/router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MedoqColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: const BoxDecoration(
                color: MedoqColors.primaryNavy,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: MedoqColors.cyanAccent,
                        child: const Text(
                          'AN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: MedoqColors.cyanAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Amadou Niang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+221 77 XXX XX XX',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatBadge(label: 'Réservations', value: '12'),
                      Container(
                        width: 1,
                        height: 32,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _StatBadge(label: 'Pharmacies', value: '5'),
                      Container(
                        width: 1,
                        height: 32,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _StatBadge(label: 'Économisé', value: '2h15'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle('Mon compte'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    items: [
                      _MenuItem(
                        icon: Icons.person_rounded,
                        label: 'Mes informations',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.location_on_rounded,
                        label: 'Mes adresses',
                        badge: '2',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.notifications_rounded,
                        label: 'Notifications',
                        onTap: () {},
                        hasSwitch: true,
                        switchValue: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle('Mes données de santé'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    items: [
                      _MenuItem(
                        icon: Icons.favorite_rounded,
                        label: 'Médicaments favoris',
                        badge: '6',
                        onTap: () {},
                        color: MedoqColors.redError,
                      ),
                      _MenuItem(
                        icon: Icons.history_rounded,
                        label: 'Historique',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.medical_information_rounded,
                        label: 'Mon dossier médical',
                        onTap: () {},
                        color: MedoqColors.cyanAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _SectionTitle('Aide & Support'),
                  const SizedBox(height: 8),
                  _MenuCard(
                    items: [
                      _MenuItem(
                        icon: Icons.help_rounded,
                        label: 'Centre d\'aide',
                        onTap: () {},
                      ),
                      _MenuItem(
                        icon: Icons.chat_rounded,
                        label: 'Contacter le support',
                        onTap: () {},
                        color: MedoqColors.greenAvailable,
                      ),
                      _MenuItem(
                        icon: Icons.star_rounded,
                        label: 'Évaluer l\'application',
                        onTap: () {},
                        color: MedoqColors.orangeLimited,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Logout
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MedoqColors.redError.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: MedoqColors.redError.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: MedoqColors.redError, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Se déconnecter',
                            style: TextStyle(
                              color: MedoqColors.redError,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Medoq v1.0.0 — © 2026 Medoq SAS',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  const _StatBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: MedoqColors.textSecondary,
            letterSpacing: 1,
          ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;
  final Color? color;
  final bool hasSwitch;
  final bool switchValue;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
    this.color,
    this.hasSwitch = false,
    this.switchValue = false,
  });
}

class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(
            children: [
              GestureDetector(
                onTap: item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: (item.color ?? MedoqColors.primaryNavy)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.color ?? MedoqColors.primaryNavy,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.label,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      if (item.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: MedoqColors.lightBlueBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.badge!,
                            style: const TextStyle(
                              color: MedoqColors.primaryNavy,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (item.hasSwitch)
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: item.switchValue,
                            onChanged: (_) {},
                            activeColor: MedoqColors.primaryNavy,
                          ),
                        )
                      else if (item.badge == null)
                        const Icon(Icons.chevron_right_rounded,
                            color: MedoqColors.textSecondary, size: 20),
                    ],
                  ),
                ),
              ),
              if (i < items.length - 1)
                const Padding(
                  padding: EdgeInsets.only(left: 66),
                  child: Divider(height: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
