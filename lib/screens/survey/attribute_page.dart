import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
import 'package:guild_companion/providers/character_provider.dart';
import 'package:guild_companion/screens/survey/origin_page.dart';

/// Pagina del questionario per descrittore caratteriale, attributi e dono.
class AttributePage extends ConsumerStatefulWidget {
  const AttributePage({super.key});

  @override
  /// Crea lo stato associato alla pagina degli attributi.
  ConsumerState<AttributePage> createState() => _AttributePageState();
}

class _AttributePageState extends ConsumerState<AttributePage> {
  final TextEditingController _descriptorController = TextEditingController();

  final List<String> _attributes = const [
    'Razionalità',
    'Empatia',
    'Impeto',
    'Acume',
    'Carisma',
    'Tenacia',
  ];

  final Map<String, int> _attributeDice = {
    'Razionalità': 8,
    'Empatia': 8,
    'Impeto': 8,
    'Acume': 8,
    'Carisma': 8,
    'Tenacia': 8,
  };

  final Map<String, Map<int, int>> _distributions = const {
    'Bilanciato': {6: 1, 8: 4, 10: 1},
    'Eclettico': {6: 2, 8: 2, 10: 2},
    'Autistico (Eccentrico)': {6: 3, 8: 0, 10: 3},
  };

  final List<_GiftOption> _gifts = const [
    _GiftOption(
      id: 'vita',
      title: 'Dono del Santo della Vita',
      description:
          'La tua ambra ottiene una sfumatura gialla brillante. Sei nato sotto il buon auspicio dei nuovi inizi, della chiarezza e dell’intuizione. Sei portato a capire le giovani idee e se qualcosa di nuovo sta per nascere. Porta con te questo consiglio: “L’alba può esistere solo vi è anche un tramonto”.\n\nUna volta per Sessione puoi concentrarti per sprigionare energia magica, la tua Ambra si illumina leggermente e puoi creare una fiamma che dura pochi minuti se non viene alimentata. Agli occhi dei fanciulli questo fuoco sembra più luminoso e meraviglioso del normale.',
    ),
    _GiftOption(
      id: 'morte',
      title: 'Dono del Santo della Morte',
      description:
          'La tua ambra ottiene una sfumatura viola profondo. Sei nato sotto il buon auspicio dei ricordi, dell’esperienza e dell’autorevolezza. Sei portato a raccogliere i frutti della tua vita e capire quando qualcosa sta giungendo al termine. Porta con te questo consiglio: “Fai tesoro del passato ma non rimanerne prigioniero”.\n\nUna volta per Sessione puoi concentrarti per sprigionare energia magica, la tua Ambra si illumina leggermente e puoi spegnere uno o più luci all’interno di una stanza, tu ottieni per il resto della scena la possibilità di vedere in questo buio. Le persone anziane si addolciscono e si addormentano più facilmente in questa oscurità.',
    ),
    _GiftOption(
      id: 'caos',
      title: 'Dono del Santo del Caos',
      description:
          'La tua ambra ottiene una sfumatura rossa acceso. Sei nato sotto il buon auspicio del cambiamento, dell’iniziativa e del coraggio. Sei portato ad adattarti facilmente e a cercare sempre stimoli diversi. Porta con te questo consiglio: “Il cambiamento è necessario, ma non tutti ne possono giovare”.\n\nUna volta per Sessione puoi concentrarti per sprigionare energia magica, la tua Ambra si illumina leggermente e puoi dare vigore ad un elemento, come far divampare una fiamma, raffreddare o riscaldare dell’acqua o intensificare una brezza in una folata improvvisa. I ragazzi sono particolarmente stimolati o ispirati da questa manifestazione.',
    ),
    _GiftOption(
      id: 'armonia',
      title: 'Dono del Santo dell’Armonia',
      description:
          'La tua Ambra del Battesimo ottiene una sfumatura verde tenue. Sei nato sotto il buon auspicio della comprensione, della mediazione e dei legami. Sei portato ad accudire il prossimo e a cercare equilibrio. Porta con te questo consiglio: “Amare qualcuno vuol anche dire saperlo lasciare andare”.\n\nUna volta per Sessione puoi concentrarti per sprigionare energia magica, la tua Ambra si illumina leggermente e puoi percepire lo stato emotivo di un altra creatura o trasmettere il tuo. Le figure genitoriali o gli sposi novelli sono particolarmente coinvolti dalle tue emozioni trasmesse.',
    ),
    _GiftOption(
      id: 'mente',
      title: 'Dono del Santo della Mente',
      description:
          'La tua Ambra del Battesimo ottiene una sfumatura azzurra chiara. Sei nato sotto il buon auspicio della consapevolezza, della logica e della lungimiranza. Sei portato ad apprendere nuove nozioni e a pianificare per ottenere risultati. Porta con te questo consiglio: “Analizzando ogni momento, spesso non lo si sta vivendo”.\n\nUna volta per Sessione puoi concentrarti per sprigionare energia magica, la tua Ambra si illumina leggermente e puoi percepire la presenza di qualcosa di nascosto in una stanza o che ti viene celato in un discorso. Le persone adulte riescono a nasconderti con più difficoltà ciò che intuisci con questo tuo dono.',
    ),
    _GiftOption(
      id: 'corpo',
      title: 'Dono del Santo del Corpo',
      description:
          'La tua Ambra del Battesimo ottiene una sfumatura arancione intenso. Sei nato sotto il buon auspicio dell’affidabilità, del vigore e del pragmatismo. Sei portato a sopportare condizioni avverse e perseguire i tuoi obiettivi. Porta con te questo consiglio: “Se combatti una vita, spesso scorderai lo scopo della battaglia”.\n\nUna volta per Sessione puoi concentrarti per sprigionare energia magica, la tua Ambra si illumina leggermente e puoi superare per un attimo i tuoi limiti fisici, sollevando, correndo o saltando il doppio di quello che faresti normalmente. I giovani vengono incoraggiati e sostenuti maggiormente dalla tua prestanza fisica.',
    ),
  ];

  String _selectedDistribution = 'Bilanciato';
  String _selectedGiftId = 'vita';
  String? _expandedGiftId;
  final Set<String> _selectedSkills = {};

  @override
  /// Rilascia le risorse del controller quando la pagina viene smontata.
  void dispose() {
    _descriptorController.dispose();
    super.dispose();
  }

  /// Calcola i dadi rimanenti in base alla distribuzione selezionata
  /// e alle assegnazioni correnti degli attributi.
  Map<int, int> _remainingDice() {
    final allowed = _distributions[_selectedDistribution] ?? const {};
    final used = <int, int>{};
    for (final die in _attributeDice.values) {
      used[die] = (used[die] ?? 0) + 1;
    }
    final remaining = <int, int>{};
    for (final entry in allowed.entries) {
      remaining[entry.key] = entry.value - (used[entry.key] ?? 0);
    }
    return remaining;
  }

  @override
  /// Costruisce la UI del questionario attributi/dono/skill.
  Widget build(BuildContext context) {
    final remaining = _remainingDice();
    return Scaffold(
      appBar: AppBar(title: const Text('Questionario: Attributi e Dono')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrittore caratteriale',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Come definiresti il tuo carattere?'),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptorController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Es. Riflessivo, impulsivo, curioso…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Distribuzione attributi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Seleziona una distribuzione di dadi.'),
            const SizedBox(height: 12),
            ..._distributions.entries.map(
              (entry) => RadioListTile<String>(
                value: entry.key,
                groupValue: _selectedDistribution,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedDistribution = value);
                },
                title: Text(entry.key),
                subtitle: Text(
                  entry.value.entries
                      .map((e) => '${e.value}d${e.key}')
                      .join(' - '),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: remaining.entries.map((entry) {
                final count = entry.value;
                final isOver = count < 0;
                return Chip(
                  label: Text(
                    'd${entry.key}: ${count >= 0 ? count : 0} rimasti',
                  ),
                  backgroundColor: isOver
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.surfaceVariant,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Attributi', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Assegna un dado a ciascun attributo.'),
            const SizedBox(height: 12),
            ..._attributes.map(
              (attribute) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(child: Text(attribute)),
                    DropdownButton<int>(
                      value: _attributeDice[attribute],
                      items: const [6, 8, 10]
                          .map(
                            (die) => DropdownMenuItem<int>(
                              value: die,
                              child: Text('d$die'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _attributeDice[attribute] = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Dono dell’Ambra',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Seleziona il dono del Battesimo.'),
            const SizedBox(height: 12),
            ..._gifts.map((gift) {
              final isExpanded = _expandedGiftId == gift.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Material(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              onTap: () {
                                setState(() => _selectedGiftId = gift.id);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: gift.id,
                                      groupValue: _selectedGiftId,
                                      onChanged: (value) {
                                        if (value == null) return;
                                        setState(() => _selectedGiftId = value);
                                      },
                                    ),
                                    Expanded(child: Text(gift.title)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: isExpanded
                                ? 'Nascondi descrizione'
                                : 'Mostra descrizione',
                            icon: AnimatedRotation(
                              duration: const Duration(milliseconds: 150),
                              turns: isExpanded ? 0.5 : 0,
                              child: const Icon(Icons.keyboard_arrow_down),
                            ),
                            onPressed: () {
                              setState(() {
                                _expandedGiftId = isExpanded ? null : gift.id;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(gift.description),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final notifier = ref.read(characterProvider.notifier);
                      notifier.setAttributeDice(_attributeDice);
                      notifier.setSkills(_selectedSkills);

                      final Character? created = await Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (_) => const OriginPage(),
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

class _GiftOption {
  final String id;
  final String title;
  final String description;

  const _GiftOption({
    required this.id,
    required this.title,
    required this.description,
  });
}
