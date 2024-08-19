// main.dart
import 'package:flutter/material.dart';
import 'controller/card_game_controller.dart';
import 'view/card_game_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CardGameController(),
      child: const MaterialApp(
        home: CardGameView(),
      ),
    );
  }
}
