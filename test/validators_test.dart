import 'package:flutter_test/flutter_test.dart';
import 'package:ilac_takip/services/validators.dart';

void main() {
  group('required', () {
    test('boş ve yalnızca boşluk geçersiz', () {
      expect(Validators.required(null), Validators.emptyMessage);
      expect(Validators.required(''), Validators.emptyMessage);
      expect(Validators.required('   '), Validators.emptyMessage);
    });

    test('dolu alan geçerli', () {
      expect(Validators.required('Ayşe'), isNull);
    });
  });

  group('email', () {
    test('boş e-posta "boş bırakılamaz" der', () {
      expect(Validators.email(''), Validators.emptyMessage);
    });

    test('hatalı biçimler geçersiz', () {
      for (final value in [
        'ayse',
        'ayse@',
        'ayse@site',
        '@site.com',
        'a b@c.com',
      ]) {
        expect(
          Validators.email(value),
          Validators.invalidEmailMessage,
          reason: value,
        );
      }
    });

    test('doğru biçimler geçerli (baştaki/sondaki boşluk yok sayılır)', () {
      expect(Validators.email('ayse@ornek.com'), isNull);
      expect(Validators.email('  ayse.yilmaz@ornek.com.tr '), isNull);
    });
  });

  group('password', () {
    test('boş ve 6 karakterden kısa şifre geçersiz', () {
      expect(Validators.password(''), Validators.emptyMessage);
      expect(Validators.password('12345'), Validators.shortPasswordMessage);
    });

    test('6 karakter ve üstü geçerli', () {
      expect(Validators.password('123456'), isNull);
    });
  });

  group('confirmPassword', () {
    test('boş veya farklı şifre geçersiz', () {
      expect(Validators.confirmPassword('', 'abcdef'), Validators.emptyMessage);
      expect(
        Validators.confirmPassword('abcdeg', 'abcdef'),
        Validators.passwordMismatchMessage,
      );
    });

    test('aynı şifre geçerli', () {
      expect(Validators.confirmPassword('abcdef', 'abcdef'), isNull);
    });
  });
}
