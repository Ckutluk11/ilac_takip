import 'package:flutter/material.dart';

import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/header_page.dart';

/// "Ailem" sekmesi (aile paneli). İleride aile üyesi davet etme ve onların
/// ilaç durumunu görme burada olacak.
class FamilyTab extends StatelessWidget {
  const FamilyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeaderPage(
      header: TabHeader(
        title: 'Ailem',
        subtitle: 'Yakınlarınızla ilaç takibini paylaşın.',
      ),
      children: [
        AppCard(
          child: EmptyState(
            icon: Icons.groups_outlined,
            title: 'Henüz kimse eklenmedi',
            message:
                'Aile paneli yakında burada olacak. Yakınlarınız, ilaçlarınızı '
                'zamanında içip içmediğinizi görebilecek.',
          ),
        ),
      ],
    );
  }
}
