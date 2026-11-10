import 'package:flutter/material.dart';

import '../../constants/app_info.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/header_page.dart';

/// "Bugün" sekmesi: giriş yapınca ilk açılan ekran. İleride bugün içilecek
/// ilaçlar saat sırasıyla, "İçtim / Atladım" butonlarıyla burada listelenecek.
class TodayTab extends StatelessWidget {
  const TodayTab({super.key, required this.user});

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
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    // Türkçe tarih, ör. "Salı, 10 Kasım 2026".
    final today = MaterialLocalizations.of(context).formatFullDate(now);
    final onPrimary = textTheme.bodyLarge?.copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w500,
    );

    return HeaderPage(
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const LogoMark(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppInfo.name,
                  style: textTheme.titleLarge?.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
              const AccountButton(),
            ],
          ),
          const SizedBox(height: 24),
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
      children: const [
        AppCard(
          child: EmptyState(
            icon: Icons.medication_outlined,
            title: 'Bugün için ilaç yok',
            message:
                'İlaç eklediğinizde, bugün içmeniz gerekenler saatleriyle '
                'burada görünecek.',
          ),
        ),
      ],
    );
  }
}
