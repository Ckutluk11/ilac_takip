import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/header_page.dart';
import 'kvkk_screen.dart';

/// "Hesabım" ekranı: kullanıcı bilgileri, KVKK metni ve çıkış.
/// Sekmelerin üst bandındaki "Hesabım" butonuyla açılır.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    // Yanlışlıkla çıkış yapılmasın diye önce sorulur.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış yapılsın mı?'),
        content: const Text(
          'Tekrar girmek için e-posta adresiniz ve şifreniz gerekecek.',
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // Bu ekran ana ekranın üstüne açıldı; önce kapatılır, sonra çıkış
    // yapılır. AuthGate giriş ekranına kendisi geçer.
    Navigator.of(context).popUntil((route) => route.isFirst);
    await ref.read(authServiceProvider).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      body: HeaderPage(
        header: Column(
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
                'Hesabım',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Adınız',
                  value: user?.name ?? '',
                ),
                const Divider(height: 32, color: AppColors.divider),
                _InfoRow(
                  icon: Icons.mail_outline_rounded,
                  label: 'E-posta',
                  // Sığmazsa kelimenin ortasından değil, @ işaretinden
                  // önce alt satıra geçsin (görünmez bölme noktası).
                  value: (user?.email ?? '').replaceAll('@', '​@'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const KvkkScreen())),
            icon: const Icon(Icons.description_outlined, size: 28),
            label: const Text('KVKK Aydınlatma Metni'),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context, ref),
            icon: const Icon(Icons.logout_rounded, size: 28),
            label: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
}

/// İkon + küçük etiket + büyük değer satırı (ör. "E-posta: ayse@...").
class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MergeSemantics(
      child: Row(
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(value, style: textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
