import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
import 'package:guild_companion/providers/character_provider.dart';
import 'package:guild_companion/screens/survey/background_page.dart';

/// Pagina del questionario per origini e equipaggiamento iniziale.
class OriginPage extends ConsumerStatefulWidget {
  const OriginPage({super.key});

  @override
  ConsumerState<OriginPage> createState() => _OriginPageState();
}

class _OriginPageState extends ConsumerState<OriginPage> {
  final TextEditingController _descriptorController = TextEditingController();

  final List<String> _fronds = const [
    'Ducato',
    'Shogunato',
    'Principato',
    'Arcipelago',
    'Mar del Nord',
    'Deserto (Baazar)',
    'Utopia',
  ];

  final Map<String, List<String>> _frondDomains = const {
    'Ducato': [
      'Intrattenimento',
      'Artigianato',
      'Caccia',
      'Cultura',
      'Religione',
      'Scherma',
    ],
    'Shogunato': [
      'Scherma',
      'Atletica',
      'Lotta',
      'Religione',
      'Artigianato',
      'Comunione',
    ],
    'Principato': [
      'Incantesimi',
      'Nobiltà',
      'Religione',
      'Scherma',
      'Cultura',
      'Intrattenimento',
    ],
    'Arcipelago': [
      'Comunione',
      'Tradizione',
      'Caccia',
      'Crimine',
      'Atletica',
      'Incantesimi',
    ],
    'Mar del Nord': [
      'Lotta',
      'Tradizione',
      'Atletica',
      'Caccia',
      'Viaggio',
      'Intrattenimento',
    ],
    'Deserto (Baazar)': [
      'Viaggio',
      'Tradizione',
      'Artigianato',
      'Crimine',
      'Lotta',
      'Nobiltà',
    ],
    'Utopia': [
      'Comunione',
      'Cultura',
      'Viaggio',
      'Nobiltà',
      'Crimine',
      'Incantesimi',
    ],
  };

  final Map<String, List<String>> _frondItems = const {
    'Ducato': [
      'Libro di narrativa/poesia',
      'Strumento Musicale',
      'Strumento Artistico',
      'Kit da Cucina',
      'Ingrediente Speciale',
    ],
    'Shogunato': [
      'Incensi per i Kami',
      'Ventaglio',
      'Pergamena sul Bushido',
      'Pennelli ed Inchiostro',
      'Bacchette e Ciotola personale',
    ],
    'Principato': [
      'Manuale su un argomento tecnico specifico',
      'Lettera di Raccomandazione',
      'Ambra finemente lavorata',
      'Ciondolo con ritratto di famiglia',
      'Profumo',
    ],
    'Arcipelago': [
      'Fiaschetta di Rum',
      'Erbe sedative',
      'Coltellino',
      'Abiti Tribali Arcipelago',
      'Strumenti per tatuaggi',
    ],
    'Mar del Nord': [
      'Accetta da lavoro',
      'Fiaschetta di Idromele',
      'Abiti Tribali Mare del Nord',
      'Mantello di lana/pelliccia',
      'Rete',
    ],
    'Deserto (Baazar)': [
      'Narghilè',
      'Pergamena e matita',
      'Abiti Tribali Deserto',
      'Borsa con molte tasche',
      'Borraccia',
    ],
    'Utopia': [
      'Lascito di Thomas',
      'Strumento Musicale',
      'Libro a scelta',
      'Collana fatta a mano',
      'Razioni',
    ],
  };

  String _selectedFrond = 'Ducato';
  final Set<String> _selectedDomains = {};
  final Set<String> _selectedItems = {};

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

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else if (_selectedItems.length < 3) {
        _selectedItems.add(item);
      }
    });
  }

  void _onFrondChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedFrond = value;
      _selectedDomains.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final domains = _frondDomains[_selectedFrond] ?? const [];
    final items = _frondItems[_selectedFrond] ?? const [];
    return Scaffold(
      appBar: AppBar(title: const Text('Questionario: Origini')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrittore origini',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Da dove provieni e cosa ti è rimasto impresso dalla tua cultura?',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptorController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Es. Ho vissuto tra mercanti e spezie…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Fronda di provenienza',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Scegli la tua fronda di origine.'),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedFrond,
              items: _fronds
                  .map(
                    (frond) => DropdownMenuItem<String>(
                      value: frond,
                      child: Text(frond),
                    ),
                  )
                  .toList(),
              onChanged: _onFrondChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            Text(
              'Ambiti fronda',
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
              'Equipaggiamento iniziale',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Scegli 3 oggetti:'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((item) {
                final selected = _selectedItems.contains(item);
                final canSelect = selected || _selectedItems.length < 3;
                return FilterChip(
                  label: Text(item),
                  selected: selected,
                  onSelected: canSelect ? (_) => _toggleItem(item) : null,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final notifier = ref.read(characterProvider.notifier);
                      notifier.addInventoryItems(items);

                      final Character? created = await Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (_) => const BackgroundPage(),
                            ),
                          );

                      if (!mounted || created == null) {
                        return;
                      }

                      Navigator.of(context).pop(created);
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
