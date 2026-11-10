import 'package:flutter/material.dart';

import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/header_page.dart';

/// "Geçmiş" sekmesi. İleride hangi ilacın hangi gün içildiği / atlandığı
/// takvim görünümünde ve haftalık özetle burada gösterilecek.
class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeaderPage(
      header: TabHeader(
        title: 'Geçmiş',
        subtitle: 'Hangi ilacı ne zaman içtiğiniz.',
      ),
      children: [
        AppCard(
          child: EmptyState(
            icon: Icons.event_note_outlined,
            title: 'Henüz kayıt yok',
            message:
                'İlaçlarınızı "İçtim" veya "Atladım" olarak işaretledikçe '
                'geçmişiniz burada görünecek.',
          ),
        ),
      ],
    );
  }
}
