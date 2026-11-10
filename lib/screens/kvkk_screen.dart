import 'package:flutter/material.dart';

import '../constants/kvkk_text.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/header_band.dart';
import '../widgets/primary_button.dart';

/// Kartın, üstteki bandın üzerine ne kadar bineceği.
const double _cardOverlap = 40;

/// KVKK aydınlatma metni. Uzun bir metin olduğu için küçük bir pencere
/// yerine tam ekranda, büyük yazıyla gösterilir.
class KvkkScreen extends StatelessWidget {
  const KvkkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBand(
              bottomPadding: _cardOverlap + 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Geri',
                    iconSize: 32,
                    color: AppColors.onPrimary,
                    style: IconButton.styleFrom(
                      minimumSize: const Size(
                        AppSizes.minTouchTarget,
                        AppSizes.minTouchTarget,
                      ),
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(height: 16),
                  Semantics(
                    header: true,
                    child: Text(
                      KvkkText.title,
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Son güncelleme: ${KvkkText.lastUpdated}',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
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
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(KvkkText.intro, style: textTheme.bodyLarge),
                            for (final section in KvkkText.sections)
                              _SectionView(section: section),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Kapat',
                        onPressed: () => Navigator.of(context).pop(),
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

class _SectionView extends StatelessWidget {
  const _SectionView({required this.section});

  final KvkkSection section;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Tek paragraflı bölümler düz metin, çok maddeli olanlar liste olarak
    // gösterilir.
    final isList = section.paragraphs.length > 1;

    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              section.title,
              style: textTheme.titleMedium?.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          for (final paragraph in section.paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: isList
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 12),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(paragraph, style: textTheme.bodyLarge),
                        ),
                      ],
                    )
                  : Text(paragraph, style: textTheme.bodyLarge),
            ),
        ],
      ),
    );
  }
}
