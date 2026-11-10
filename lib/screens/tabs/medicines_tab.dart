import 'package:flutter/material.dart';

import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/header_page.dart';

/// "İlaçlarım" sekmesi. İleride eklenen ilaçlar; stok ve son kullanma tarihi
/// bilgisiyle burada listelenecek. İlaca dokununca detay ve prospektüs açılacak.
class MedicinesTab extends StatelessWidget {
  const MedicinesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeaderPage(
      header: TabHeader(
        title: 'İlaçlarım',
        subtitle: 'İlaçlarınız, stokları ve son kullanma tarihleri.',
      ),
      children: [
        AppCard(
          child: EmptyState(
            icon: Icons.medication_outlined,
            title: 'Henüz ilaç eklenmedi',
            message: 'İlaç ekleme özelliği yakında burada olacak.',
          ),
        ),
      ],
    );
  }
}
