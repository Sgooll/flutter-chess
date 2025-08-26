import 'package:flutter/material.dart';
import 'package:flutter_chess/src/feature/menu/main_menu.dart';

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: const MainMenuScreen(),
    );
  }
}