/// Form doğrulama kuralları. Her fonksiyon geçerliyse `null`,
/// değilse kullanıcıya gösterilecek Türkçe hata mesajını döndürür.
abstract final class Validators {
  static const String emptyMessage = 'Bu alan boş bırakılamaz.';
  static const String invalidEmailMessage = 'Geçerli bir e-posta adresi girin.';
  static const String shortPasswordMessage = 'Şifre en az 6 karakter olmalı.';
  static const String passwordMismatchMessage = 'Şifreler aynı değil.';
  static const String consentMessage =
      'Devam etmek için onay kutusunu işaretleyin.';

  static const int minPasswordLength = 6;

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return emptyMessage;
    return null;
  }

  static String? email(String? value) {
    final emptyError = required(value);
    if (emptyError != null) return emptyError;
    if (!_emailPattern.hasMatch(value!.trim())) return invalidEmailMessage;
    return null;
  }

  /// Şifrede boşluklar da karakter sayılır, bu yüzden `trim` yapılmaz.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return emptyMessage;
    if (value.length < minPasswordLength) return shortPasswordMessage;
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return emptyMessage;
    if (value != password) return passwordMismatchMessage;
    return null;
  }
}
