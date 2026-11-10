/// Giriş yapmış kullanıcı.
class AppUser {
  const AppUser({required this.id, required this.name, required this.email});

  final String id;
  final String name;
  final String email;
}

/// Kimlik doğrulama sırasında oluşan, kullanıcıya gösterilebilir hata.
///
/// [message] her zaman Türkçe ve kullanıcıya doğrudan gösterilecek şekilde
/// yazılmalıdır (ör. "Bu e-posta adresi zaten kayıtlı.").
class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => 'AuthException: $message';
}

/// Giriş/kayıt işlemlerinin arayüzü.
///
/// Ekranlar yalnızca bu arayüzü bilir. Şimdilik [FakeAuthService] kullanılıyor;
/// Firebase eklendiğinde `FirebaseAuthService` yazılıp `auth_providers.dart`
/// içindeki tek satır değiştirilecek.
abstract interface class AuthService {
  /// Oturum durumu değiştikçe (giriş/çıkış) yeni değer yayar.
  /// Dinlemeye başlanınca önce mevcut durumu verir.
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  /// Hata durumunda [AuthException] fırlatır.
  Future<AppUser> signIn({required String email, required String password});

  /// Hata durumunda [AuthException] fırlatır.
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Hata durumunda [AuthException] fırlatır.
  Future<void> sendPasswordReset(String email);

  Future<void> signOut();
}
