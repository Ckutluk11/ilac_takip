import 'package:flutter/material.dart';

import '../screens/account_screen.dart';
import '../theme/app_theme.dart';
import 'header_band.dart';

/// Uygulamanın sayfa düzeni: üstte turkuaz [HeaderBand], altında içerik.
/// İçeriğin üst kısmı bandın üzerine biner ([overlap]). Sayfanın tamamı
/// kaydırılabilir.
class HeaderPage extends StatelessWidget {
  const HeaderPage({
    super.key,
    required this.header,
    required this.children,
    this.overlap = 40,
  });

  /// Bandın içinde gösterilecek başlık alanı.
  final Widget header;

  /// Bandın altındaki içerik (genellikle bir veya birkaç kart).
  final List<Widget> children;

  final double overlap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          HeaderBand(
            bottomPadding: overlap + 28,
            // Tam genişlik: başlık kısa olsa da ortalanmasın, solda dursun.
            child: SizedBox(width: double.infinity, child: header),
          ),
          Transform.translate(
            offset: Offset(0, -overlap),
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
                    ...children,
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sekme sayfalarının bant içindeki başlığı: solda başlık ve açıklama,
/// sağ üstte "Hesabım" butonu.
class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(alignment: Alignment.centerRight, child: AccountButton()),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          child: Text(
            title,
            style: textTheme.headlineMedium?.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Bandın sağ üstündeki "Hesabım" butonu. Sadece ikon değil, yazısı da var.
class AccountButton extends StatelessWidget {
  const AccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const AccountScreen())),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.onPrimary,
        backgroundColor: Colors.white.withValues(alpha: 0.14),
        minimumSize: const Size(
          AppSizes.minTouchTarget,
          AppSizes.minTouchTarget,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Tema TextButton'ları altı çizili yapar; bu bir buton, bağlantı değil.
        textStyle: Theme.of(context).textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radius),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
        ),
      ),
      icon: const Icon(Icons.account_circle_outlined, size: 28),
      label: const Text('Hesabım'),
    );
  }
}
