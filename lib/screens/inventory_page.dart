import 'package:flutter/material.dart';
import 'package:guild_companion/models/character.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final items = character.inventory.entries.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: items.isEmpty
          ? Center(
              child: Text(
                'Nessun oggetto nell\'inventario',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final entry = items[index];
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('x${entry.value}'),
                );
              },
            ),
    );
  }
}
