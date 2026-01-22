import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giornale')),
      body: const Center(child: Text('Eventi, quest e log del gioco')),
    );
  }
}
