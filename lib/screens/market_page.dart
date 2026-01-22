import 'package:flutter/material.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mercato')),
      body: const Center(child: Text('Bacheca del mercato e scambi')),
    );
  }
}
