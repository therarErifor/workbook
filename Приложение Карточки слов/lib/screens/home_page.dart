import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/storage_service.dart';
import 'flashcard_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final _storage = StorageService();
  List<FlashcardSet> sets = [];

  @override
  void initState() {
    super.initState();
    _loadSets();
  }

  void _loadSets() async {
    final loaded = await _storage.loadSets();
    setState(() {
      sets = loaded;
    });
  }

  void _showAddSetDialog(BuildContext context) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Название набора'),
        content: TextField(controller: nameController),
        actions: [
          TextButton(
            onPressed: () {
              List<Flashcard> _cards = [Flashcard(front: 'Лицевая сторона', back: 'Задняя сторона')];
              final name = nameController.text;
              if (name.isNotEmpty) {
                final newSet = FlashcardSet(name: name, cards: _cards);
                setState(() => sets.add(newSet));
                _storage.saveSets(sets);
              }
              Navigator.pop(context);
            },
            child: Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _removeSet(int index) {
    // Запрашиваем подтверждение перед удалением
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удалить набор?'),
          content: Text('Вы уверены, что хотите удалить этот набор?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  sets.removeAt(index); // Удаляем набор
                });
                Navigator.of(context).pop();
              },
              child: Text('Да'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Нет'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Наборы карточек')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSetDialog(context),
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: sets.length,
        itemBuilder: (context, index) {
          final set = sets[index];
          return ListTile(
            title: Text(set.name),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeSet(index), // Удаление набора
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FlashcardPage(set: set),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
