import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
import 'package:guild_companion/providers/character_provider.dart';
import 'package:guild_companion/screens/overview_page.dart';
import 'package:guild_companion/screens/survey/survey_main_page.dart';
import 'package:guild_companion/theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> _openSurvey() async {
    final Character? created = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SurveyMainPage()));

    if (created == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    ref.read(characterProvider.notifier).selectCharacter(created);

    final characters = ref.read(characterProvider).characters;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            OverviewPage(characters: characters, selectedCharacter: created),
      ),
    );
  }

  Future<void> _openOverview(Character character) async {
    final characters = ref.read(characterProvider).characters;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            OverviewPage(characters: characters, selectedCharacter: character),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characters = ref.watch(characterProvider).characters;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleziona personaggio'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openSurvey,
        icon: const Icon(Icons.add),
        label: const Text('Nuovo personaggio'),
      ),
      body: characters.isEmpty
          ? _emptyState(context)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: characters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final character = characters[index];
                return _characterCard(character);
              },
            ),
    );
  }

  Widget _characterCard(Character character) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openOverview(character),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  character.name.isNotEmpty
                      ? character.name.characters.first.toUpperCase()
                      : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${character.archetype} • Livello ${character.level}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_alt_1,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Nessun personaggio trovato',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Crea il tuo primo personaggio per iniziare l\'avventura.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
