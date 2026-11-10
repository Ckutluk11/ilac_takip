/// Uygulamanın adı ve sloganı. İsim değişirse yalnızca burayı değiştir.
///
/// Not: Telefonun ana ekranında görünen ad Dart kodundan okunamaz;
/// isim değişince şu iki dosyayı da elle güncelle:
/// - android/app/src/main/AndroidManifest.xml → android:label
/// - ios/Runner/Info.plist → CFBundleDisplayName
abstract final class AppInfo {
  static const String name = 'Saatinde';
  static const String slogan = 'İlaçlarınız, tam saatinde.';
}
