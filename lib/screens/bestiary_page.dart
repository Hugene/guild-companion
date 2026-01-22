import 'package:flutter/material.dart';

class BestiaryPage extends StatelessWidget {
  const BestiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bestiario')),
      body: const Center(child: Text('Qui visualizzi il bestiario')),
    );
  }
}
