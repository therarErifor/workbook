class Flashcard {
  final String front;
  final String back;

  Flashcard({required this.front, required this.back});
}

class FlashcardSet {
  final String name;
  final List<Flashcard> cards;

  FlashcardSet({required this.name, List<Flashcard>? cards}): cards = cards ?? [];
}