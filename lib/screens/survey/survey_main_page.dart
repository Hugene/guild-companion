import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
import 'package:guild_companion/providers/character_provider.dart';
import 'package:guild_companion/screens/survey/attribute_page.dart';

class SurveyMainPage extends ConsumerStatefulWidget {
  const SurveyMainPage({super.key});

  @override
  ConsumerState<SurveyMainPage> createState() => _SurveyMainPageState();
}

class _SurveyMainPageState extends ConsumerState<SurveyMainPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _archetypeController = TextEditingController();
  final _levelController = TextEditingController(text: '1');

  @override
  void dispose() {
    _nameController.dispose();
    _archetypeController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final level = int.tryParse(_levelController.text.trim()) ?? 1;

    final notifier = ref.read(characterProvider.notifier);
    notifier.resetDraft();
    notifier.setBaseInfo(
      name: _nameController.text.trim(),
      archetype: _archetypeController.text.trim(),
      level: level,
    );

    final Character? created = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AttributePage()));

    if (!mounted || created == null) {
      return;
    }

    Navigator.of(context).pop(created);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Benvenuto nella GILDA!'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Rispondi alle domande per creare il tuo personaggio.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome personaggio',
                  hintText: 'Es. Mario Pallario',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inserisci un nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Crea personaggio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
