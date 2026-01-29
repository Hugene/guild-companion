import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
import 'package:guild_companion/providers/character_provider.dart';
import 'package:guild_companion/screens/MOIRA.dart';

/// Pagina del questionario per background e oggetti iniziali.
class BackgroundPage extends ConsumerStatefulWidget {
  const BackgroundPage({super.key});

  @override
  ConsumerState<BackgroundPage> createState() => _BackgroundPageState();
}

class _BackgroundPageState extends ConsumerState<BackgroundPage> {
  final TextEditingController _descriptorController = TextEditingController();

  final List<String> _backgrounds = const [
    'Studioso',
    'Seminarista',
    'Pregiudicato',
    'Allievo della Gilda',
    'Artigiano',
    'Contadino',
    'Nobile',
    'Abitante Tribù',
    'Soldato/Guardia',
    'Cacciatore',
    'Mercante',
    'Eremita',
    'Artista',
    'Stregone',
  ];

  final Map<String, List<String>> _backgroundDomains = const {
    'Studioso': [
      'Incantesimi',
      'Religione',
      'Nobiltà',
      'Cultura',
      'Artigianato',
    ],
    'Seminarista': [
      'Incantesimi',
      'Religione',
      'Cultura',
      'Scherma',
      'Comunione',
    ],
    'Pregiudicato': [
      'Nobiltà',
      'Crimine',
      'Scherma',
      'Lotta',
      'Intrattenimento',
    ],
    'Allievo della Gilda': [
      'Incantesimi',
      'Lotta',
      'Caccia',
      'Viaggio',
      'Atletica',
    ],
    'Artigiano': [
      'Tradizione',
      'Crimine',
      'Incantesimi',
      'Viaggio',
      'Artigianato',
    ],
    'Contadino': [
      'Tradizione',
      'Lotta',
      'Religione',
      'Atletica',
      'Artigianato',
    ],
    'Nobile': [
      'Incantesimi',
      'Intrattenimento',
      'Nobiltà',
      'Cultura',
      'Scherma',
    ],
    'Abitante Tribù': [
      'Tradizione',
      'Lotta',
      'Caccia',
      'Comunione',
      'Atletica',
    ],
    'Soldato/Guardia': ['Crimine', 'Scherma', 'Lotta', 'Caccia', 'Atletica'],
    'Cacciatore': ['Scherma', 'Caccia', 'Comunione', 'Viaggio', 'Atletica'],
    'Mercante': [
      'Nobiltà',
      'Crimine',
      'Intrattenimento',
      'Viaggio',
      'Artigianato',
    ],
    'Eremita': ['Tradizione', 'Religione', 'Caccia', 'Comunione', 'Viaggio'],
    'Artista': [
      'Tradizione',
      'Cultura',
      'Crimine',
      'Intrattenimento',
      'Artigianato',
    ],
    'Stregone': [
      'Comunione',
      'Religione',
      'Cultura',
      'Nobiltà',
      'Intrattenimento',
    ],
  };

  final Map<String, List<String>> _backgroundItems = const {
    'Studioso': ['Tunica Semplice', 'Libro di Appunti Accademici'],
    'Seminarista': ['Tunica Semplice', 'Libro di Preghiere'],
    'Pregiudicato': ['Grimaldelli', 'Mantello con Cappuccio'],
    'Allievo della Gilda': ['Bandoliera', 'Torce e Acciarino'],
    'Artigiano': [
      'Set Attrezzi di un mestiere a scelta',
      'Taccuino con matita',
    ],
    'Contadino': ['Razione di Cibo', 'Cappello di Paglia'],
    'Nobile': ['Anello con Sigillo di Famiglia', 'Abiti di buona fattura'],
    'Abitante Tribù': ['Amuleto della Tribù', 'Cimelio degli antenati'],
    'Soldato/Guardia': ['Corno da segnalazione o fischietto', 'Manette'],
    'Cacciatore': ['Corde', 'Trappola'],
    'Mercante': ['Bilancia Portatile', 'Documenti/Permessi'],
    'Eremita': ['Kit da Cucina', 'Amuleto personale'],
    'Artista': [
      'Vestiti appariscenti',
      'Strumento Artistico o Musicale a scelta',
    ],
    'Stregone': ['Attestato da Stregone', 'Abiti di buona fattura'],
  };

  String _selectedBackground = 'Studioso';
  final Set<String> _selectedDomains = {};

  @override
  void dispose() {
    _descriptorController.dispose();
    super.dispose();
  }

  void _toggleDomain(String domain) {
    setState(() {
      if (_selectedDomains.contains(domain)) {
        _selectedDomains.remove(domain);
      } else if (_selectedDomains.length < 2) {
        _selectedDomains.add(domain);
      }
    });
  }

  void _onBackgroundChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedBackground = value;
      _selectedDomains.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final domains = _backgroundDomains[_selectedBackground] ?? const [];
    final items = _backgroundItems[_selectedBackground] ?? const [];
    return Scaffold(
      appBar: AppBar(title: const Text('Questionario: Background')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrittore background',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Cosa facevi prima di diventare un avventuriero?'),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptorController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Es. Ho studiato tra antichi manoscritti…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text('Background', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Scegli il tuo background.'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedBackground,
              items: _backgrounds
                  .map(
                    (background) => DropdownMenuItem<String>(
                      value: background,
                      child: Text(background),
                    ),
                  )
                  .toList(),
              onChanged: _onBackgroundChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            Text(
              'Ambiti background',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Scegli 2 ambiti (selezionati: ${_selectedDomains.length}/2).',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: domains.map((domain) {
                final selected = _selectedDomains.contains(domain);
                final canSelect = selected || _selectedDomains.length < 2;
                return FilterChip(
                  label: Text(domain),
                  selected: selected,
                  onSelected: canSelect ? (_) => _toggleDomain(domain) : null,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Oggetti background',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ottieni 2 Oggetti, rappresentano qualcosa che hai tenuto dal tuo lavoro:',
            ),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final notifier = ref.read(characterProvider.notifier);
                      notifier.addInventoryItems(items);
                      final Character created = notifier.buildCharacter();
                      notifier.resetDraft();
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => Moira()));
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Conferma e continua'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
