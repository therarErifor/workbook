import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class FlashcardPage extends StatefulWidget {
  final FlashcardSet set;

  FlashcardPage({required this.set});

  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int currentIndex = 0;
  bool isFront = true;

  void _flipCard() {
    setState(() {
      isFront = !isFront;
    });
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.set.cards.length;
      isFront = true;
    });
  }

  void _addCard() {
    showDialog(
      context: context,
      builder: (context) {
        String front = '';
        String back = '';
        return AlertDialog(
          title: Text('Новая карточка'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Лицевая сторона'),
                onChanged: (value) => front = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Задняя сторона'),
                onChanged: (value) => back = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (front.isNotEmpty && back.isNotEmpty) {
                  setState(() {
                    widget.set.cards.add(Flashcard(front: front, back: back));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  // Удалить карточку
  void _removeCard(int index) {
    setState(() {
      if (index > 0) {
        widget.set.cards.removeAt(index);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final card = widget.set.cards[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(widget.set.name)),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _flipCard,
                child: Container(
                  width: 300,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(blurRadius: 4)],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isFront ? card.front : card.back,
                    style: TextStyle(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _nextCard,
                child: Text('Следующая'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _addCard,
                  child: Text('Добавить карту')
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: ()=> _removeCard(currentIndex),
                  child: Text('Удалить карту')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
