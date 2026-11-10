import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'message_box.dart';

/// Büyük yazılı giriş alanı.
///
/// Etiket her zaman alanın üstünde görünür (yazmaya başlayınca kaybolmaz).
/// [errorText] verilirse kenarlık kalın kırmızı olur ve hata, alanın altında
/// ikonlu kutuda gösterilir.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.errorText,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.obscureText = false,
    this.enabled = true,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;

  /// Alanın başındaki ikon (ör. e-posta için zarf). Yalnızca görsel ipucu;
  /// alanın ne olduğu her zaman [label] ile yazılı olarak da söylenir.
  final IconData? icon;
  final String? errorText;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool enabled;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          autofillHints: enabled ? autofillHints : null,
          obscureText: obscureText,
          autocorrect: !obscureText,
          enableSuggestions: !obscureText,
          style: const TextStyle(fontSize: 22, color: AppColors.text),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon == null
                ? null
                : Icon(
                    icon,
                    size: 28,
                    color: hasError ? AppColors.error : null,
                  ),
            suffixIcon: suffix,
            enabledBorder: hasError
                ? AppTheme.errorBorder(focused: false)
                : null,
            focusedBorder: hasError
                ? AppTheme.errorBorder(focused: true)
                : null,
          ),
        ),
        AnimatedMessage(message: errorText),
      ],
    );
  }
}
