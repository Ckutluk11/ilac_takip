import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum MessageType { error, success }

/// İkonlu, büyük yazılı mesaj kutusu.
///
/// Hata ve başarı yalnızca renkle değil; ikon, kenarlık ve yazıyla
/// birlikte anlatılır. Ekran okuyucu mesajı belirince otomatik okur.
class MessageBox extends StatelessWidget {
  const MessageBox(this.message, {super.key, this.type = MessageType.error});

  const MessageBox.success(this.message, {super.key})
    : type = MessageType.success;

  final String message;
  final MessageType type;

  @override
  Widget build(BuildContext context) {
    final isError = type == MessageType.error;
    final color = isError ? AppColors.error : AppColors.success;
    final background = isError
        ? AppColors.errorBackground
        : AppColors.successBackground;
    final icon = isError
        ? Icons.warning_amber_rounded
        : Icons.check_circle_outline;

    return Semantics(
      liveRegion: true,
      label: isError ? 'Hata: $message' : message,
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: color,
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

/// [message] `null` değilse [MessageBox] gösterir; mesaj belirip kaybolurken
/// ekran zıplamaz, yumuşakça açılıp kapanır.
class AnimatedMessage extends StatelessWidget {
  const AnimatedMessage({
    super.key,
    required this.message,
    this.type = MessageType.error,
    this.topSpacing = 8,
  });

  final String? message;
  final MessageType type;
  final double topSpacing;

  @override
  Widget build(BuildContext context) {
    final duration = AppTheme.animationDuration(context);

    return AnimatedSize(
      duration: duration,
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: duration,
        child: message == null
            ? const SizedBox(width: double.infinity)
            : Padding(
                key: ValueKey('$type:$message'),
                padding: EdgeInsets.only(top: topSpacing),
                child: MessageBox(message!, type: type),
              ),
      ),
    );
  }
}
