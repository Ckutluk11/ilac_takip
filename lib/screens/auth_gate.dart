import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/message_box.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Oturum durumuna göre ekran seçer: kullanıcı varsa ana ekran,
/// yoksa giriş ekranı. Giriş/çıkış yapılınca ekran kendiliğinden değişir;
/// ekranların birbirini elle açıp kapatmasına gerek kalmaz.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) =>
          user == null ? const LoginScreen() : HomeScreen(user: user),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            child: MessageBox(
              'Bir sorun oluştu. Lütfen uygulamayı kapatıp yeniden açın.',
            ),
          ),
        ),
      ),
    );
  }
}
