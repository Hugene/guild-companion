import 'package:guild_companion/models/dice.dart';

class Character {
  final String name;
  final String archetype;
  final int level;
  final Map<String, List<Dice>> attributes;
  final Map<String, int> scope;
  final List<String> skills;
  final Map<String, int> inventory;
  final String? sheetId;

  Character({
    required this.name,
    required this.archetype,
    required this.level,
    required this.attributes,
    required this.scope,
    required this.skills,
    required this.inventory,
    this.sheetId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'archetype': archetype,
      'level': level,
      'attributes': attributes.map(
        (key, value) => MapEntry(key, value.map((dice) => dice.sides).toList()),
      ),
      'scope': scope,
      'skills': skills,
      'inventory': inventory,
      'sheetId': sheetId,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    final rawAttributes =
        (json['attributes'] as Map?)?.cast<String, dynamic>() ?? {};
    final attributes = rawAttributes.map(
      (key, value) => MapEntry(
        key,
        (value as List<dynamic>).map((entry) => Dice(entry as int)).toList(),
      ),
    );

    return Character(
      name: json['name'] as String? ?? '',
      archetype: json['archetype'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      attributes: attributes,
      scope: _intMap(json['scope']),
      skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? const [],
      inventory: _intMap(json['inventory']),
      sheetId: json['sheetId'] as String?,
    );
  }

  static Map<String, int> _intMap(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val as int));
    }
    return const {};
  }
}
