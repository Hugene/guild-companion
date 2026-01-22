import 'package:guild_companion/models/dice.dart';

class Character {
  final String name;
  final String arketype;
  final int level;
  final Map<String, List<Dice>> attributes;
  final Map<String, int> scope;
  final List<String> skills;
  final Map<String, int> inventory;
  final String? sheetId;

  Character({
    required this.name,
    required this.arketype,
    required this.level,
    required this.attributes,
    required this.scope,
    required this.skills,
    required this.inventory,
    this.sheetId,
  });
}