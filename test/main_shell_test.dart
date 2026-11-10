import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ilac_takip/screens/main_shell.dart';
import 'package:ilac_takip/services/auth_service.dart';
import 'package:ilac_takip/theme/app_theme.dart';

void main() {
  testWidgets('alt çubukla sekmeler arasında geçilir', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const MainShell(
          user: AppUser(id: '1', name: 'Ayşe', email: 'ayse@ornek.com'),
        ),
      ),
    );

    // Açılışta "Bugün" sekmesi görünür.
    expect(find.text('Merhaba, Ayşe'), findsOneWidget);

    Future<void> openTab(String label, String expected) async {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(expected), findsOneWidget);
    }

    await openTab('İlaçlarım', 'Henüz ilaç eklenmedi');
    await openTab('Geçmiş', 'Henüz kayıt yok');
    await openTab('Ailem', 'Henüz kimse eklenmedi');
    await openTab('Bugün', 'Bugün için ilaç yok');
  });
}
