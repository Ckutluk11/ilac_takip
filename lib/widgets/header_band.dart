import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Ekranın üstündeki koyu turkuaz bant (alt köşeleri yuvarlak).
///
/// Durum çubuğu (saat, pil) ikonlarını beyaz yapar, böylece koyu zeminde
/// okunur kalırlar. [bottomPadding], altına binecek kart için boşluk bırakır.
class HeaderBand extends StatelessWidget {
  const HeaderBand({super.key, required this.child, this.bottomPadding = 72});

  final Widget child;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary],
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        ),
        child: Stack(
          children: [
            // Süs amaçlı, çok soluk daireler (derinlik hissi verir).
            const Positioned(top: -60, right: -40, child: _Circle(size: 200)),
            const Positioned(bottom: -70, left: -50, child: _Circle(size: 160)),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.screenPadding,
                  16,
                  AppSizes.screenPadding,
                  bottomPadding,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: AppSizes.maxContentWidth,
                    ),
                    child: child,
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

class _Circle extends StatelessWidget {
  const _Circle({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
    );
  }
}
