import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guild_companion/models/character.dart';
import 'package:guild_companion/models/dice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CharacterDraft {
  final String name;
  final String archetype;
  final int level;
  final Map<String, int> attributeDice;
  final List<String> skills;
  final Map<String, int> inventory;

  const CharacterDraft({
    required this.name,
    required this.archetype,
    required this.level,
    required this.attributeDice,
    required this.skills,
    required this.inventory,
  });

  CharacterDraft copyWith({
    String? name,
    String? archetype,
    int? level,
    Map<String, int>? attributeDice,
    List<String>? skills,
    Map<String, int>? inventory,
  }) {
    return CharacterDraft(
      name: name ?? this.name,
      archetype: archetype ?? this.archetype,
      level: level ?? this.level,
      attributeDice: attributeDice ?? this.attributeDice,
      skills: skills ?? this.skills,
      inventory: inventory ?? this.inventory,
    );
  }
}

class CharacterState {
  final List<Character> characters;
  final CharacterDraft draft;
  final Character? selected;

  const CharacterState({
    required this.characters,
    required this.draft,
    this.selected,
  });

  CharacterState copyWith({
    List<Character>? characters,
    CharacterDraft? draft,
    Character? selected,
  }) {
    return CharacterState(
      characters: characters ?? this.characters,
      draft: draft ?? this.draft,
      selected: selected ?? this.selected,
    );
  }
}

class CharacterNotifier extends Notifier<CharacterState> {
  static const _charactersKey = 'characters.v1';
  static const _selectedIndexKey = 'characters.selectedIndex.v1';

  bool _didLoad = false;

  @override
  CharacterState build() {
    if (!_didLoad) {
      _didLoad = true;
      Future.microtask(_loadFromPrefs);
    }
    return CharacterState(
      characters: [
        Character(
          name: 'Erminio Brass',
          archetype: 'Guerriero',
          level: 5,
          attributes: const {},
          scope: const {},
          skills: const [],
          inventory: const {},
        ),
        Character(
          name: 'Nino Dangerous',
          archetype: 'Ladro',
          level: 2,
          attributes: const {},
          scope: const {},
          skills: const [],
          inventory: const {},
        ),
      ],
      draft: const CharacterDraft(
        name: '',
        archetype: '',
        level: 5,
        attributeDice: {},
        skills: [],
        inventory: {},
      ),
    );
  }

  void resetDraft() {
    state = state.copyWith(
      draft: const CharacterDraft(
        name: '',
        archetype: '',
        level: 5,
        attributeDice: {},
        skills: [],
        inventory: {},
      ),
    );
  }

  void setBaseInfo({
    required String name,
    required String archetype,
    required int level,
  }) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        name: name,
        archetype: archetype,
        level: level,
      ),
    );
  }

  void setAttributeDice(Map<String, int> diceByAttribute) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        attributeDice: Map<String, int>.from(diceByAttribute),
      ),
    );
  }

  void setSkills(Set<String> skills) {
    state = state.copyWith(
      draft: state.draft.copyWith(skills: skills.toList()),
    );
  }

  void addInventoryItems(List<String> items) {
    final updated = Map<String, int>.from(state.draft.inventory);
    for (final item in items) {
      updated[item] = (updated[item] ?? 0) + 1;
    }
    state = state.copyWith(draft: state.draft.copyWith(inventory: updated));
  }

  void selectCharacter(Character character) {
    state = state.copyWith(selected: character);
    _saveToPrefs();
  }

  void updateCharacter(Character updated) {
    final next = state.characters
        .map((character) => character == state.selected ? updated : character)
        .toList();
    state = state.copyWith(characters: next, selected: updated);
    _saveToPrefs();
  }

  Character buildCharacter() {
    final attributes = <String, List<Dice>>{};
    state.draft.attributeDice.forEach((key, value) {
      attributes[key] = [Dice(value)];
    });

    final created = Character(
      name: state.draft.name,
      archetype: state.draft.archetype,
      level: state.draft.level,
      attributes: attributes,
      scope: const {},
      skills: state.draft.skills,
      inventory: state.draft.inventory,
    );

    state = state.copyWith(
      characters: [...state.characters, created],
      selected: created,
    );

    _saveToPrefs();

    return created;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_charactersKey)) {
      return;
    }

    final raw = prefs.getString(_charactersKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    final characters = decoded
        .map((entry) => Character.fromJson(entry as Map<String, dynamic>))
        .toList();

    final selectedIndex = prefs.getInt(_selectedIndexKey);
    final selected =
        (selectedIndex != null &&
            selectedIndex >= 0 &&
            selectedIndex < characters.length)
        ? characters[selectedIndex]
        : null;

    state = state.copyWith(characters: characters, selected: selected);
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(
      state.characters.map((c) => c.toJson()).toList(),
    );
    await prefs.setString(_charactersKey, payload);

    final selectedIndex = state.selected == null
        ? -1
        : state.characters.indexOf(state.selected!);
    if (selectedIndex >= 0) {
      await prefs.setInt(_selectedIndexKey, selectedIndex);
    } else {
      await prefs.remove(_selectedIndexKey);
    }
  }
}

final characterProvider = NotifierProvider<CharacterNotifier, CharacterState>(
  CharacterNotifier.new,
);
