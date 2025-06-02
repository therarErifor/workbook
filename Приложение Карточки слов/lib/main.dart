import 'package:flutter/material.dart';
import 'screens/home_page.dart'; // импорт начального экрана

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Карточки',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(), // начальный экран
    );
  }
}
