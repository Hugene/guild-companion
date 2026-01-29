import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
import 'package:guild_companion/screens/home_page.dart';
import 'package:guild_companion/screens/settings_page.dart';
import 'package:guild_companion/theme.dart';
import 'bestiary_page.dart';
import 'character_sheet_page.dart';
import 'market_page.dart';
import 'journal_page.dart';
import 'inventory_page.dart';

class OverviewPage extends ConsumerStatefulWidget {
  const OverviewPage({
    super.key,
    required this.characters,
    required this.selectedCharacter,
  });

  final List<Character> characters;
  final Character selectedCharacter;

  @override
  ConsumerState<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends ConsumerState<OverviewPage> {
  late Character _selectedCharacter = widget.selectedCharacter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => HomePage())),
        ),
        title: Text(_selectedCharacter.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _featureCard(
              context,
              title: 'Scheda',
              icon: Icons.person,
              backgroundColor: AppColors.secondary,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CharacterSheetPage()),
              ),
            ),
            _featureCard(
              context,
              title: 'Inventario',
              icon: Icons.backpack,
              backgroundColor: AppColors.error,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => InventoryPage(character: _selectedCharacter),
                ),
              ),
            ),
            _featureCard(
              context,
              title: 'Bestiario',
              icon: Icons.pets,
              backgroundColor: AppColors.primary,
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const BestiaryPage())),
            ),
            _featureCard(
              context,
              title: 'Mercato',
              icon: Icons.storefront,
              backgroundColor: AppColors.tertiary,
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const MarketPage())),
            ),
            _featureCard(
              context,
              title: 'Giornale',
              icon: Icons.book,
              backgroundColor: AppColors.accent,
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const JournalPage())),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: backgroundColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: AppColors.onPrimary),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.onPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
