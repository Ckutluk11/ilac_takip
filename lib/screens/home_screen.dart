import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_info.dart';
import '../services/auth_providers.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_logo.dart';
import '../widgets/header_band.dart';

const double _cardOverlap = 40;

/// Geçici ana ekran. İlaç listesi gelince yeniden tasarlanacak.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.user});

  final AppUser user;

  /// Günün saatine göre selamlama.
  static String greetingFor(DateTime time) {
    final hour = time.hour;
    if (hour >= 5 && hour < 11) return 'Günaydın!';
    if (hour >= 11 && hour < 17) return 'İyi günler!';
    if (hour >= 17 && hour < 22) return 'İyi akşamlar!';
    return 'İyi geceler!';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    // Türkçe tarih, ör. "Salı, 10 Kasım 2026".
    final today = MaterialLocalizations.of(context).formatFullDate(now);
    final onPrimary = textTheme.bodyLarge?.copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBand(
              bottomPadding: _cardOverlap + 28,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const LogoMark(size: 40),
                      const SizedBox(width: 12),
                      Text(
                        AppInfo.name,
                        style: textTheme.titleLarge?.copyWith(
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(greetingFor(now), style: onPrimary),
                  const SizedBox(height: 4),
                  Semantics(
                    header: true,
                    child: Text(
                      'Merhaba, ${user.name}',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.onPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(today, style: onPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -_cardOverlap),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.maxContentWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(child: _EmptyMedicines(textTheme: textTheme)),
                      const SizedBox(height: 28),
                      OutlinedButton.icon(
                        onPressed: () =>
                            ref.read(authServiceProvider).signOut(),
                        icon: const Icon(Icons.logout_rounded, size: 28),
                        label: const Text('Çıkış Yap'),
                      ),
                      SizedBox(
                        height: MediaQuery.paddingOf(context).bottom + 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Henüz ilaç yokken gösterilen kart.
class _EmptyMedicines extends StatelessWidget {
  const _EmptyMedicines({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.medication_outlined,
            size: 52,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Henüz ilaç eklenmedi',
          textAlign: TextAlign.center,
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'İlaçlarınızı ekleme özelliği yakında burada olacak.',
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
