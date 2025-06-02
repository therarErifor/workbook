import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';

class StorageService {
  static const _key = 'flashcard_sets';

  Future<void> saveSets(List<FlashcardSet> sets) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      sets.map((s) => {
        'name': s.name,
        'cards': s.cards.map((c) => {'front': c.front, 'back': c.back}).toList(),
      }).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  Future<List<FlashcardSet>> loadSets() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map<FlashcardSet>((setJson) {
      final cards = (setJson['cards'] as List<dynamic>).map((c) {
        return Flashcard(front: c['front'], back: c['back']);
      }).toList();

      return FlashcardSet(name: setJson['name'], cards: cards);
    }).toList();
  }
}
