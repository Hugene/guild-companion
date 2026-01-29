import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
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
        leading: PopupMenuButton<Character>(
          tooltip: 'Seleziona personaggio',
          icon: const Icon(Icons.account_circle_outlined),
          onSelected: (value) {
            setState(() => _selectedCharacter = value);
          },
          itemBuilder: (context) => widget.characters
              .map(
                (character) => PopupMenuItem<Character>(
                  value: character,
                  child: Row(
                    children: [
                      Icon(
                        character == _selectedCharacter
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 18,
                        color: character == _selectedCharacter
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 8),
                      Text(character.name),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        title: Text(_selectedCharacter.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
            },
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
                MaterialPageRoute(builder: (_) => const InventoryPage()),
              ),
            ),
            _featureCard(
              context,
              title: 'Bestiario',
              icon: Icons.pets,
              backgroundColor: AppColors.primary,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BestiaryPage()),
              ),
            ),
            _featureCard(
              context,
              title: 'Mercato',
              icon: Icons.storefront,
              backgroundColor: AppColors.tertiary,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MarketPage()),
              ),
            ),
            _featureCard(
              context,
              title: 'Giornale',
              icon: Icons.book,
              backgroundColor: AppColors.accent,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const JournalPage()),
              ),
            ),
          ],
        ),
      ),);
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
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.onPrimary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}