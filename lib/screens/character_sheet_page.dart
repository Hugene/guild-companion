import 'package:flutter/material.dart';

class CharacterSheetPage extends StatelessWidget {
  const CharacterSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schede')),
      body: const Center(child: Text('Qui gestisci le schede dei personaggi')),
    );
  }
}
