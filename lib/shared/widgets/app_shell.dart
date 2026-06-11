import 'package:flutter/material.dart';

import 'package:calcflow/l10n/app_localizations.dart';
import '../../features/calculator/presentation/calculator_screen.dart';
import '../../features/converter/presentation/converter_screen.dart';
import '../../features/finance/presentation/finance_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

/// Root navigation shell: 4 destinations, one Scaffold, no nested app bars.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _index,
          children: const [
            CalculatorScreen(),
            ConverterScreen(),
            FinanceScreen(),
            SettingsScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate_rounded),
            label: l10n.navCalculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.swap_horiz_rounded),
            selectedIcon: const Icon(Icons.swap_horiz_rounded),
            label: l10n.navConverter,
          ),
          NavigationDestination(
            icon: const Icon(Icons.percent_outlined),
            selectedIcon: const Icon(Icons.percent_rounded),
            label: l10n.navFinance,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
