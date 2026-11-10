import 'package:flutter/material.dart';

/// Uygulamanın renkleri.
///
/// Tüm metin renkleri kendi zemini üzerinde en az 7:1 kontrast oranı sağlar
/// (WCAG AAA). Renk tek başına anlam taşımaz: hata ve başarı durumları her
/// zaman ikon + yazı ile birlikte gösterilir.
abstract final class AppColors {
  /// Koyu turkuaz. Beyaz yazıyla kontrastı 8.5:1.
  static const Color primary = Color(0xFF00574B);
  static const Color primaryDark = Color(0xFF00463B);
  static const Color onPrimary = Colors.white;

  /// Açık turkuaz zemin (kartlar, ikon daireleri). Üzerindeki
  /// [primary] yazının kontrastı 7.4:1.
  static const Color primaryContainer = Color(0xFFDDF0EC);

  /// Yalnızca süs amaçlı (logo rozeti). Metin rengi olarak kullanılmaz.
  static const Color accent = Color(0xFFFFB300);

  static const Color background = Color(0xFFF2F6F5);
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF1A1F1E);
  static const Color textSecondary = Color(0xFF3F4A48);

  /// Giriş alanı kenarlığı. Beyaz zeminde 4.5:1 (WCAG 1.4.11 için 3:1 yeter).
  static const Color border = Color(0xFF6B7A77);
  static const Color divider = Color(0xFFDCE4E2);

  static const Color error = Color(0xFF9B1C1C);
  static const Color errorBackground = Color(0xFFFDECEC);

  static const Color success = Color(0xFF1B5E20);
  static const Color successBackground = Color(0xFFE8F5E9);
}

/// Ölçüler. Dokunma alanları en az 56 px olmalı.
abstract final class AppSizes {
  static const double minTouchTarget = 56;
  static const double buttonHeight = 64;
  static const double radius = 16;
  static const double cardRadius = 24;
  static const double screenPadding = 20;
  static const double cardPadding = 24;
  static const double fieldSpacing = 20;

  /// Geniş ekranlarda (tablet) formun aşırı yayılmasını önler.
  static const double maxContentWidth = 480;
}

abstract final class AppTheme {
  static const String fontFamily = 'AtkinsonHyperlegibleNext';

  /// Animasyon süresi. Telefonda "animasyonları kaldır" açıksa sıfır olur.
  static Duration animationDuration(BuildContext context) {
    return MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 220);
  }

  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.primary,
      onSecondary: AppColors.onPrimary,
      error: AppColors.error,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
    );

    const textTheme = TextTheme(
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: AppColors.text,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.text,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        height: 1.45,
        color: AppColors.text,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        height: 1.45,
        color: AppColors.text,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    );

    final roundedShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
    );

    OutlineInputBorder inputBorder(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 64,
        iconTheme: IconThemeData(size: 32),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(AppSizes.buttonHeight, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge,
          shape: roundedShape,
          elevation: 2,
          shadowColor: AppColors.primaryDark.withValues(alpha: 0.4),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: AppColors.surface,
          minimumSize: const Size(AppSizes.buttonHeight, AppSizes.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: textTheme.labelLarge,
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: roundedShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(
            AppSizes.minTouchTarget,
            AppSizes.minTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: roundedShape,
          // Bağlantılar altı çizili: yalnızca renge bağlı kalmasın.
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        hintStyle: const TextStyle(
          fontSize: 20,
          color: AppColors.textSecondary,
        ),
        prefixIconColor: AppColors.textSecondary,
        prefixIconConstraints: const BoxConstraints(minWidth: 56),
        border: inputBorder(AppColors.border, 2),
        enabledBorder: inputBorder(AppColors.border, 2),
        focusedBorder: inputBorder(AppColors.primary, 3),
        disabledBorder: inputBorder(AppColors.divider, 2),
      ),
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.border, width: 2.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        titleTextStyle: textTheme.titleLarge?.copyWith(fontFamily: fontFamily),
        contentTextStyle: textTheme.bodyLarge?.copyWith(fontFamily: fontFamily),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      // Alt gezinme çubuğu: normalinden yüksek, yazılar her zaman görünür.
      // Seçili sekme renk + dolu ikon + arka plan hapı + kalın yazıyla belli.
      navigationBarTheme: NavigationBarThemeData(
        height: 88,
        backgroundColor: AppColors.surface,
        elevation: 8,
        shadowColor: AppColors.primaryDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 30,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: fontFamily,
            fontSize: 17,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Hatalı alanın kenarlığı (kalın, kırmızı). Hata ayrıca ikonlu kutuda yazılır.
  static OutlineInputBorder errorBorder({required bool focused}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      borderSide: BorderSide(color: AppColors.error, width: focused ? 4 : 3),
    );
  }
}
