import 'app_info.dart';

/// KVKK (6698 sayılı Kişisel Verilerin Korunması Kanunu) madde 10 gereği
/// kullanıcıya gösterilen aydınlatma metni.
///
/// Not: Bitirme projesi için hazırlanmış bir taslaktır. Uygulama mağazaya
/// çıkmadan önce bir hukukçuya kontrol ettirilmelidir. Uygulamaya yeni bir
/// veri türü ya da yeni bir hizmet (ör. başka bir sunucu) eklenirse bu metin
/// de güncellenmelidir.
abstract final class KvkkText {
  static const String title = 'KVKK Aydınlatma Metni';

  /// Veri sorumlusu (uygulamanın geliştiricisi).
  static const String dataController = 'Caner Kutluk';

  static const String lastUpdated = 'Kasım 2026';

  static const String intro =
      'Bu metin, ${AppInfo.name} uygulamasını kullanırken kişisel '
      'verilerinizin nasıl işlendiğini 6698 sayılı Kişisel Verilerin '
      'Korunması Kanunu (KVKK) gereği size açıklamak için hazırlanmıştır.';

  static const List<KvkkSection> sections = [
    KvkkSection(
      title: '1. Veri sorumlusu',
      paragraphs: [
        'Kişisel verileriniz, veri sorumlusu sıfatıyla ${AppInfo.name} '
            'uygulamasının geliştiricisi $dataController tarafından işlenir.',
      ],
    ),
    KvkkSection(
      title: '2. Hangi verilerinizi işliyoruz?',
      paragraphs: [
        'Kimlik bilgisi: adınız.',
        'İletişim bilgisi: e-posta adresiniz.',
        'Hesap güvenliği bilgisi: şifreniz. Şifreniz şifrelenmiş olarak '
            'saklanır; uygulamanın geliştiricisi dahil kimse şifrenizi göremez.',
        'Sağlık verileri: uygulamaya eklediğiniz ilaçlar, doz saatleri, '
            '"içtim / atladım" kayıtları, ilaç stoku ve son kullanma tarihleri. '
            'Bunlar KVKK\'ya göre özel nitelikli kişisel veridir ve daha '
            'sıkı korunur.',
        'Görsel veriler: ilaç eklerken çektiğiniz ilaç kutusu fotoğrafları.',
        'Aile paneli bilgileri: verilerinizi görmesine izin verdiğiniz '
            'aile üyelerinin hesapları.',
      ],
    ),
    KvkkSection(
      title: '3. Verilerinizi neden işliyoruz?',
      paragraphs: [
        'Hesabınızı oluşturmak, giriş yapmanızı sağlamak ve şifrenizi '
            'unuttuğunuzda sıfırlama bağlantısı göndermek.',
        'İlaç saatlerinizi size hatırlatmak ve ilaç geçmişinizi tutmak.',
        'Stok azaldığında veya son kullanma tarihi yaklaştığında sizi '
            'uyarmak.',
        'Yalnızca siz izin verirseniz, seçtiğiniz aile üyelerinin ilaç '
            'takibinizi görebilmesini sağlamak.',
        'Hesabınızın güvenliğini sağlamak.',
        'Verileriniz reklam amacıyla kullanılmaz ve satılmaz.',
      ],
    ),
    KvkkSection(
      title: '4. Verilerinizi nasıl ve hangi hukuki sebeple topluyoruz?',
      paragraphs: [
        'Verileriniz, uygulamaya sizin girdiğiniz bilgilerden elektronik '
            'ortamda toplanır.',
        'Ad, e-posta ve şifre; uygulamayı kullanabilmeniz için gereklidir '
            '(KVKK md. 5/2-c: bir sözleşmenin kurulması ve ifası). Hesap '
            'güvenliği için yapılan işlemler, veri sorumlusunun meşru '
            'menfaatine dayanır (KVKK md. 5/2-f).',
        'Sağlık verileriniz, açık rızanıza dayanarak işlenir (KVKK md. 6). '
            'İlaç eklemek tamamen isteğe bağlıdır.',
      ],
    ),
    KvkkSection(
      title: '5. Verileriniz kimlere aktarılır?',
      paragraphs: [
        'Hesap bilgileriniz ve buluta yedeklenen verileriniz, Google '
            'tarafından sunulan Firebase hizmetinde saklanır. Bu hizmetin '
            'sunucuları yurt dışında bulunabilir. Bu aktarım KVKK md. 9\'a '
            'uygun olarak yapılır.',
        'Aile paneli açıksa, ilaç takip bilgileriniz yalnızca sizin '
            'seçtiğiniz aile üyeleriyle paylaşılır. Bu izni istediğiniz zaman '
            'geri alabilirsiniz.',
        'Kanunen yetkili kamu kurumları talep ederse, yalnızca kanunun '
            'zorunlu kıldığı ölçüde paylaşım yapılabilir.',
      ],
    ),
    KvkkSection(
      title: '6. Verileriniz ne kadar süre saklanır?',
      paragraphs: [
        'Verileriniz, hesabınız açık olduğu sürece saklanır. Hesabınızı '
            'silmek istediğinizde verileriniz silinir veya anonim hale '
            'getirilir.',
      ],
    ),
    KvkkSection(
      title: '7. Haklarınız (KVKK md. 11)',
      paragraphs: [
        'Kişisel verilerinizin işlenip işlenmediğini öğrenme.',
        'İşlenmişse bununla ilgili bilgi isteme.',
        'İşlenme amacını ve amaca uygun kullanılıp kullanılmadığını öğrenme.',
        'Yurt içinde veya yurt dışında aktarıldığı kişileri bilme.',
        'Eksik veya yanlış işlenmişse düzeltilmesini isteme.',
        'Silinmesini veya yok edilmesini isteme.',
        'Düzeltme ve silme işlemlerinin, verilerin aktarıldığı kişilere '
            'bildirilmesini isteme.',
        'Yalnızca otomatik sistemlerle yapılan bir analiz sonucunda '
            'aleyhinize bir sonuç çıkmasına itiraz etme.',
        'Kanuna aykırı işleme nedeniyle zarara uğrarsanız zararın '
            'giderilmesini talep etme.',
      ],
    ),
    KvkkSection(
      title: '8. Nasıl başvurabilirsiniz?',
      paragraphs: [
        'Haklarınızla ilgili taleplerinizi, uygulamayı indirdiğiniz '
            'mağaza sayfasında yer alan geliştirici e-posta adresine '
            'iletebilirsiniz. Başvurunuz en geç 30 gün içinde ücretsiz '
            'olarak yanıtlanır.',
      ],
    ),
    KvkkSection(
      title: '9. Önemli uyarı',
      paragraphs: [
        '${AppInfo.name} bir hatırlatma ve takip uygulamasıdır. Doz önermez '
            've tıbbi tavsiye vermez. İlaçlarınızla ilgili her konuda '
            'doktorunuza veya eczacınıza danışın.',
      ],
    ),
  ];
}

/// Aydınlatma metninin bir bölümü: başlık ve maddeler.
class KvkkSection {
  const KvkkSection({required this.title, required this.paragraphs});

  final String title;
  final List<String> paragraphs;
}
