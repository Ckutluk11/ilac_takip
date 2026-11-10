import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'tabs/family_tab.dart';
import 'tabs/history_tab.dart';
import 'tabs/medicines_tab.dart';
import 'tabs/today_tab.dart';

/// Giriş yapınca açılan ana iskelet: altta 4 sekmeli gezinme çubuğu.
///
/// Sekmeler [IndexedStack] içinde tutulur; başka sekmeye geçip dönünce
/// kaydırma konumu gibi durumlar kaybolmaz.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.user});

  final AppUser user;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          TodayTab(user: widget.user),
          const MedicinesTab(),
          const HistoryTab(),
          const FamilyTab(),
        ],
      ),
      // Seçili sekme yalnızca renkle değil; dolu ikon, arka plan hapı ve
      // kalın yazıyla da belli olur (bkz. AppTheme navigationBarTheme).
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            selectedIcon: Icon(Icons.watch_later),
            label: 'Bugün',
          ),
          NavigationDestination(
            icon: Icon(Icons.medication_outlined),
            selectedIcon: Icon(Icons.medication),
            label: 'İlaçlarım',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Geçmiş',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Ailem',
          ),
        ],
      ),
    );
  }
}
