import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

/// Firebase Authentication (e-posta/şifre) ile çalışan [AuthService].
///
/// Firebase'in İngilizce hata kodları [authErrorMessage] ile Türkçe,
/// kullanıcıya gösterilebilir mesajlara çevrilir ve [AuthException] olarak
/// fırlatılır. Kullanıcının adı Firebase profilindeki `displayName` alanında
/// tutulur (ek bir veritabanı gerekmez).
class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  /// `authStateChanges` yerine `userChanges` kullanılıyor: kayıttan hemen
  /// sonra ad (`displayName`) güncellendiğinde de yeni değer yayar, böylece
  /// ana ekrandaki "Merhaba, [ad]" doğru adı gösterir.
  @override
  Stream<AppUser?> authStateChanges() => _auth.userChanges().map(_toAppUser);

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _guard(
      () => _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
    return _toAppUser(credential.user)!;
  }

  @override
  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _guard(
      () => _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      ),
    );
    final user = credential.user!;
    await _guard(() => user.updateDisplayName(name.trim()));
    return AppUser(id: user.uid, name: name.trim(), email: user.email ?? '');
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    // Sıfırlama e-postası Türkçe gitsin.
    await _auth.setLanguageCode('tr');
    await _guard(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  @override
  Future<void> signOut() => _auth.signOut();

  /// Firebase hatalarını Türkçe [AuthException]'a çevirir.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (e) {
      throw AuthException(authErrorMessage(e.code));
    }
  }

  static AppUser? _toAppUser(User? user) {
    if (user == null) return null;
    final email = user.email ?? '';
    final displayName = user.displayName?.trim();
    return AppUser(
      id: user.uid,
      // Ad henüz kaydedilmemişse (ör. kayıttan hemen sonraki ilk an)
      // e-postanın @ öncesini göster.
      name: (displayName == null || displayName.isEmpty)
          ? email.split('@').first
          : displayName,
      email: email,
    );
  }
}

/// Firebase Authentication hata kodunu kullanıcıya gösterilecek Türkçe
/// mesaja çevirir.
String authErrorMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Geçerli bir e-posta adresi girin.';
    // Yeni Firebase projelerinde güvenlik gereği "kullanıcı yok" ve
    // "şifre yanlış" ayrımı yapılmaz; hepsi invalid-credential döner.
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'E-posta veya şifre hatalı. Lütfen kontrol edip tekrar deneyin.';
    case 'user-disabled':
      return 'Bu hesap kullanıma kapatılmış.';
    case 'email-already-in-use':
      return 'Bu e-posta adresiyle zaten bir hesap var. Giriş yapmayı deneyin.';
    case 'weak-password':
      return 'Şifre çok zayıf. Lütfen daha uzun bir şifre seçin.';
    case 'too-many-requests':
      return 'Çok fazla deneme yapıldı. Lütfen birkaç dakika sonra tekrar deneyin.';
    case 'network-request-failed':
      return 'İnternet bağlantısı yok. Bağlantınızı kontrol edip tekrar deneyin.';
    case 'operation-not-allowed':
      return 'Bu giriş yöntemi şu anda kullanılamıyor.';
    default:
      return 'Bir sorun oluştu. Lütfen tekrar deneyin.';
  }
}
