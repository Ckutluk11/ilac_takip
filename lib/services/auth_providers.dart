import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_service.dart';
import 'fake_auth_service.dart';

/// Uygulamanın kullandığı [AuthService].
///
/// Firebase eklendiğinde yalnızca burada `FakeAuthService()` yerine
/// `FirebaseAuthService()` döndürülecek.
final authServiceProvider = Provider<AuthService>((ref) {
  final service = FakeAuthService();
  ref.onDispose(service.dispose);
  return service;
});

/// Giriş yapmış kullanıcı (yoksa `null`). Ekran geçişleri bunu dinler.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});
