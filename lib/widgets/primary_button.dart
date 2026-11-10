import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Tam genişlikte, 64 px yüksekliğinde ana buton.
///
/// [isLoading] iken buton kilitlenir (iki kez basılamaz); dönen göstergenin
/// yanında [loadingLabel] yazısı çıkar, böylece ne olduğu yazıyla da anlaşılır.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.loadingLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        // Yüklenirken buton soluklaşmasın, yazı okunur kalsın.
        style: isLoading
            ? FilledButton.styleFrom(
                disabledBackgroundColor: AppColors.primary,
                disabledForegroundColor: AppColors.onPrimary,
              )
            : null,
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(child: Text(loadingLabel ?? label)),
                ],
              )
            : Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
