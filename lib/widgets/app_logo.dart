import 'package:flutter/material.dart';

import '../constants/app_info.dart';
import '../theme/app_theme.dart';

/// Logo işareti: beyaz daire içinde saat, köşesinde hap rozeti.
///
/// Gerçek logo hazır olunca bu widget bir görselle değiştirilecek.
class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 104});

  final double size;

  @override
  Widget build(BuildContext context) {
    final badgeSize = size * 0.42;

    return ExcludeSemantics(
      child: SizedBox(
        width: size + badgeSize * 0.25,
        height: size + badgeSize * 0.25,
        child: Stack(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.schedule_rounded,
                size: size * 0.62,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 3),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  size: badgeSize * 0.58,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Koyu bant üzerinde logo, uygulama adı ve slogan.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const LogoMark(),
        const SizedBox(height: 20),
        Semantics(
          header: true,
          child: Text(
            AppInfo.name,
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(
              color: AppColors.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppInfo.slogan,
          textAlign: TextAlign.center,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
