import 'package:flutter/material.dart';
import 'package:guild_companion/models/character.dart';

class SurveyPage extends StatefulWidget {
	const SurveyPage({super.key});

	@override
	State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
	final _formKey = GlobalKey<FormState>();
	final _nameController = TextEditingController();
	final _arketypeController = TextEditingController();
	final _levelController = TextEditingController(text: '1');

	@override
	void dispose() {
		_nameController.dispose();
		_arketypeController.dispose();
		_levelController.dispose();
		super.dispose();
	}

	void _submit() {
		final form = _formKey.currentState;
		if (form == null || !form.validate()) {
			return;
		}

		final level = int.tryParse(_levelController.text.trim()) ?? 1;

		final character = Character(
			name: _nameController.text.trim(),
			arketype: _arketypeController.text.trim(),
			level: level,
			attributes: const {},
			scope: const {},
			skills: const [],
			inventory: const {},
		);

		Navigator.of(context).pop(character);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Crea personaggio'),
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
									hintText: 'Es. Elara la Rossa',
								),
								validator: (value) {
									if (value == null || value.trim().isEmpty) {
										return 'Inserisci un nome.';
									}
									return null;
								},
							),
							const SizedBox(height: 16),
							TextFormField(
								controller: _arketypeController,
								textInputAction: TextInputAction.next,
								decoration: const InputDecoration(
									labelText: 'Archetipo',
									hintText: 'Es. Bardo, Guerriero, Mago',
								),
								validator: (value) {
									if (value == null || value.trim().isEmpty) {
										return 'Inserisci un archetipo.';
									}
									return null;
								},
							),
							const SizedBox(height: 16),
							TextFormField(
								controller: _levelController,
								keyboardType: TextInputType.number,
								decoration: const InputDecoration(
									labelText: 'Livello iniziale',
									hintText: '1',
								),
								validator: (value) {
									final parsed = int.tryParse(value ?? '');
									if (parsed == null || parsed <= 0) {
										return 'Inserisci un livello valido.';
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
