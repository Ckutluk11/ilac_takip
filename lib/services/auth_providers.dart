import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_service.dart';
import 'firebase_auth_service.dart';

/// Uygulamanın kullandığı [AuthService].
///
/// Gerçek uygulamada Firebase kullanılır. Testler bunu
/// `authServiceProvider.overrideWithValue(FakeAuthService())` ile
/// sahte servisle değiştirir (bkz. test/auth_screens_test.dart).
final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

/// Giriş yapmış kullanıcı (yoksa `null`). Ekran geçişleri bunu dinler.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});
