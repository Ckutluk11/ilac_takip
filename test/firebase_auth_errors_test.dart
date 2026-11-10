import 'package:flutter_test/flutter_test.dart';
import 'package:ilac_takip/services/firebase_auth_service.dart';

void main() {
  test('yanlış şifre ve olmayan kullanıcı aynı mesajı verir', () {
    final message = authErrorMessage('invalid-credential');
    expect(authErrorMessage('wrong-password'), message);
    expect(authErrorMessage('user-not-found'), message);
    expect(message, contains('E-posta veya şifre hatalı'));
  });

  test('bilinen hatalar Türkçe mesaja çevrilir', () {
    expect(
      authErrorMessage('email-already-in-use'),
      contains('zaten bir hesap var'),
    );
    expect(
      authErrorMessage('network-request-failed'),
      contains('İnternet bağlantısı yok'),
    );
    expect(authErrorMessage('too-many-requests'), contains('Çok fazla deneme'));
  });

  test('bilinmeyen hata genel mesaj verir', () {
    expect(
      authErrorMessage('bilinmeyen-kod'),
      'Bir sorun oluştu. Lütfen tekrar deneyin.',
    );
  });
}
