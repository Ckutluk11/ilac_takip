import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_text_field.dart';

/// Göster/gizle butonlu şifre alanı.
///
/// Buton yalnızca göz ikonu değil, "Göster"/"Gizle" yazısını da içerir.
class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
    this.textInputAction,
    this.autofillHints = const [AutofillHints.password],
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? errorText;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      icon: Icons.lock_outline_rounded,
      errorText: widget.errorText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      obscureText: _obscured,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      suffix: Padding(
        padding: const EdgeInsets.only(right: 4),
        child: TextButton.icon(
          onPressed: widget.enabled
              ? () => setState(() => _obscured = !_obscured)
              : null,
          icon: Icon(
            _obscured
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 28,
          ),
          label: Text(_obscured ? 'Göster' : 'Gizle'),
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
