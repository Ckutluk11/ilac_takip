import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilac_takip/main.dart';
import 'package:ilac_takip/services/auth_providers.dart';
import 'package:ilac_takip/services/fake_auth_service.dart';
import 'package:ilac_takip/services/validators.dart';

/// Uygulamayı uzun bir telefon ekranında açar (tüm form görünsün diye).
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // Testler gerçek Firebase'e bağlanmaz; sahte servis kullanılır.
  final fakeAuth = FakeAuthService();
  addTearDown(fakeAuth.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [authServiceProvider.overrideWithValue(fakeAuth)],
      child: const IlacTakipApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Finder field(int index) => find.byType(TextField).at(index);

Future<void> tapText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

void main() {
  group('Giriş ekranı', () {
    testWidgets('boş formda iki alan için de hata gösterir', (tester) async {
      await pumpApp(tester);

      await tapText(tester, 'Giriş Yap');

      expect(find.text(Validators.emptyMessage), findsNWidgets(2));
      expect(find.byIcon(Icons.warning_amber_rounded), findsNWidgets(2));
    });

    testWidgets('geçersiz e-posta ve kısa şifre hatası', (tester) async {
      await pumpApp(tester);

      await tester.enterText(field(0), 'ayse@');
      await tester.enterText(field(1), '123');
      await tapText(tester, 'Giriş Yap');

      expect(find.text(Validators.invalidEmailMessage), findsOneWidget);
      expect(find.text(Validators.shortPasswordMessage), findsOneWidget);
    });

    testWidgets('hata, düzeltilince yazarken kaybolur', (tester) async {
      await pumpApp(tester);

      await tapText(tester, 'Giriş Yap');
      await tester.enterText(field(0), 'ayse@ornek.com');
      await tester.pumpAndSettle(); // kaybolma animasyonu bitsin

      expect(
        find.text(Validators.emptyMessage),
        findsOneWidget,
      ); // yalnızca şifre
    });

    testWidgets('şifre göster/gizle', (tester) async {
      await pumpApp(tester);

      TextField passwordField() => tester.widget<TextField>(field(1));
      expect(passwordField().obscureText, isTrue);

      await tapText(tester, 'Göster');
      expect(passwordField().obscureText, isFalse);
      expect(find.text('Gizle'), findsOneWidget);
    });

    testWidgets('doğru bilgilerle ana ekrana geçer, çıkışla geri döner', (
      tester,
    ) async {
      await pumpApp(tester);

      await tester.enterText(field(0), 'ayse@ornek.com');
      await tester.enterText(field(1), '123456');
      await tapText(tester, 'Giriş Yap');

      expect(find.text('Giriş yapılıyor…'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('Merhaba, ayse'), findsOneWidget);

      await tapText(tester, 'Çıkış Yap');
      await tester.pumpAndSettle();

      expect(find.text('Giriş Yap'), findsOneWidget);
    });

    testWidgets('şifremi unuttum: geçerli e-postada başarı mesajı', (
      tester,
    ) async {
      await pumpApp(tester);

      await tapText(tester, 'Şifremi unuttum');
      expect(find.text(Validators.emptyMessage), findsOneWidget);

      await tester.enterText(field(0), 'ayse@ornek.com');
      await tapText(tester, 'Şifremi unuttum');
      expect(find.text('Gönderiliyor…'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('şifre sıfırlama bağlantısı gönderildi'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });
  });

  group('Kayıt ekranı', () {
    Future<void> openRegister(WidgetTester tester) async {
      await pumpApp(tester);
      await tapText(tester, 'Kayıt olun');
      await tester.pumpAndSettle();
      expect(find.text('Şifre tekrarı'), findsOneWidget);
    }

    testWidgets('şifreler farklıysa ve onay yoksa hata gösterir', (
      tester,
    ) async {
      await openRegister(tester);

      await tester.enterText(field(0), 'Ayşe Yılmaz');
      await tester.enterText(field(1), 'ayse@ornek.com');
      await tester.enterText(field(2), '123456');
      await tester.enterText(field(3), '654321');
      await tester.tap(find.widgetWithText(FilledButton, 'Kayıt Ol'));
      await tester.pump();

      expect(find.text(Validators.passwordMismatchMessage), findsOneWidget);
      expect(find.text(Validators.consentMessage), findsOneWidget);
    });

    testWidgets('başarılı kayıtta ana ekranda adı gösterir', (tester) async {
      await openRegister(tester);

      await tester.enterText(field(0), 'Ayşe Yılmaz');
      await tester.enterText(field(1), 'ayse@ornek.com');
      await tester.enterText(field(2), '123456');
      await tester.enterText(field(3), '123456');
      // Satırın metnine dokunmak da kutuyu işaretler.
      await tapText(
        tester,
        'Bu uygulamanın tıbbi tavsiye vermediğini anladım, KVKK metnini okudum.',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Kayıt Ol'));
      await tester.pump();

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('Merhaba, Ayşe Yılmaz'), findsOneWidget);
      expect(find.text('Şifre tekrarı'), findsNothing); // kayıt ekranı kapandı
    });

    testWidgets('KVKK metni penceresi açılır', (tester) async {
      await openRegister(tester);

      await tapText(tester, 'KVKK metnini oku');
      await tester.pumpAndSettle();

      expect(find.text('KVKK Aydınlatma Metni'), findsOneWidget);
      await tapText(tester, 'Kapat');
      await tester.pumpAndSettle();
      expect(find.text('KVKK Aydınlatma Metni'), findsNothing);
    });
  });
}
