# Saatinde — İlaç Takip Uygulaması

> İlaçlarınız, tam saatinde.

Yaşlılar ve kronik hastalar için geliştirilen, Flutter ile yazılmış bir ilaç takip uygulaması. Bitirme projesi olarak geliştirilmektedir. Öncelikli platform Android'dir.

Uygulama ilaç saatlerini hatırlatır ve takip eder. **Doz önermez, tıbbi tavsiye vermez.**

## Planlanan özellikler

| Özellik | Durum |
|---|---|
| E-posta / şifre ile kayıt, giriş, şifre sıfırlama (Firebase Authentication) | ✅ Tamamlandı |
| KVKK aydınlatma metni | ✅ Tamamlandı (taslak) |
| Ana iskelet: Bugün · İlaçlarım · Geçmiş · Ailem sekmeleri, Hesabım ekranı | ✅ Tamamlandı (sekme içerikleri yapılacak) |
| İlaç ekleme (elle) ve yerel veritabanı (drift) | ⏳ Sırada |
| Doz hatırlatma bildirimleri | ⏳ Planlandı |
| "İçtim / Atladım" takibi ve geçmiş | ⏳ Planlandı |
| Stok ve son kullanma tarihi uyarıları | ⏳ Planlandı |
| İlaç kutusu fotoğrafından tanıma (TFLite), yedek olarak karekod / adla arama | ⏳ Planlandı |
| Aile paneli | ⏳ Planlandı |
| Prospektüs (Kullanma Talimatı) modülü | ⏳ Planlandı |

## Erişilebilirlik ilkeleri

Hedef kitle yaşlı kullanıcılar olduğu için:

- Büyük yazı ve az gören okuyucular için tasarlanmış **Atkinson Hyperlegible Next** fontu
- En az 56 px dokunma alanı, 64 px yüksekliğinde ana butonlar
- Yüksek kontrast (WCAG AAA hedefi)
- Renk tek başına anlam taşımaz: hatalar ve durumlar her zaman **ikon + yazı** ile gösterilir
- Sistemde "animasyonları kapat" ayarı açıksa animasyonlar kapanır
- Arayüz tamamen Türkçe

## Teknolojiler

- **Flutter / Dart**
- **Riverpod**: durum yönetimi
- **Firebase**: Authentication (ileride Firestore ve Storage)
- **drift**: yerel veritabanı (planlandı)
- **flutter_local_notifications**: hatırlatmalar (planlandı)

## Proje yapısı

```
lib/
├── constants/   Uygulama adı, KVKK metni
├── screens/     Ekranlar (giriş, kayıt, ana iskelet, sekmeler, hesabım)
├── services/    Kimlik doğrulama servisi (arayüz + Firebase uygulaması), form kuralları
├── theme/       Renkler, ölçüler, tema
└── widgets/     Ortak arayüz parçaları
test/            Birim ve arayüz testleri
```

## Çalıştırma

```bash
flutter pub get
flutter run        # bağlı Android cihaz veya emülatörde
flutter test       # testler
flutter analyze    # kod analizi
```
