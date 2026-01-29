import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/assets/assets.dart';
import 'package:guild_companion/providers/character_provider.dart';
import 'package:guild_companion/screens/overview_page.dart';
import 'package:audioplayers/audioplayers.dart';

class Moira extends ConsumerStatefulWidget {
  const Moira({super.key});

  @override
  ConsumerState<Moira> createState() => _MoiraState();
}

class _MoiraState extends ConsumerState<Moira> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    // Play on open
    _playElephant();
  }

  Future<void> _playElephant() async {
    try {
      await _player.play(AssetSource('elephant.mp3'));
    } catch (_) {
      // ignore errors in audio playback
    }
  }

  @override
  void dispose() {
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(characterProvider);
    final characters = state.characters;
    final selected =
        state.selected ?? (characters.isNotEmpty ? characters.first : null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ricordati che devi MOIRA!'),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (selected == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nessun personaggio disponibile')),
              );
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OverviewPage(
                  characters: characters,
                  selectedCharacter: selected,
                ),
              ),
            );
          },
          child: Image(image: AssetImage(Assets.lemoire)),
        ),
      ),
    );
  }
}
