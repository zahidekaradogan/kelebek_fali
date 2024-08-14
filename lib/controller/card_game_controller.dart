// lib/controller/card_game_controller.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../model/card_model.dart';

class CardGameController extends ChangeNotifier {
  List<CardModel> _cards = [];
  List<int> _randomOrder = [];
  int matchCount = 0;
  final Map<String, String> _matches = {};
  bool hasStarted = false;

  CardGameController() {
    _initializeGame();  // Başlangıçta tüm kartlar back_card ile başlar
  }

  List<CardModel> get cards => _cards;
  List<int> get randomOrder => _randomOrder;

  void _initializeGame() {
    // Başlangıçta tüm kartlar back_card ile gösterilecek
    _cards = List.generate(24, (index) => CardModel(
          imagePath: 'assets/images/cards/back_card.png',
          objectDescription: 'Back of the card',
        ));

    notifyListeners();  // UI'yı güncelle
  }

  void _shuffleCards() {
    final random = Random();
    _randomOrder = List.generate(_cards.length, (index) => index)..shuffle(random);

    // Kartları rastgele sırala
    for (var i = 0; i < _cards.length; i++) {
      int newIndex = _randomOrder[i];
      _cards[i] = CardModel(
        imagePath: 'assets/images/cards/${newIndex + 1}.png',
        objectDescription: 'Description for card ${newIndex + 1}',
      );
    }
  }

  void startGame() {
    hasStarted = true;
    _shuffleCards();
    matchCount = 0;
    _matches.clear();
    _checkMatches();  // Eşleşmeleri kontrol et
    notifyListeners();
  }

  void resetGame() {
    _initializeGame();  // Kartları tekrar back_card ile sıfırla
    hasStarted = false; // Butonun yeniden görünmesini sağla
  }

  void _checkMatches() {
    final horizontalMatches = {
      '1-2': '1-tac',
      '2-3': '2-kus',
      '3-4': '3-ok',
      '4-5': '4-kalp',
      '5-6': '5-mum',
      '6-1': '6-eldiven',
      '7-8': '7-can',
      '8-9': '8-nal',
      '9-10': '9-gunes',
      '10-11': '10-masa',
      '11-12': '11-kilit',
      '12-7': '12-inci',
      '13-14': '13-balon',
      '14-15': '14-yılan',
      '15-16': '15-kelebek',
      '16-17': '16-mektup',
      '17-18': '17-kitap',
      '18-13': '18-dis-fircasi',
      '19-20': '19-kalpli-ok',
      '20-21': '20-ev',
      '21-22': '21-bardak',
      '22-23': '22-terazi',
      '23-24': '23-para',
      '24-19': '24-kilic',
    };

    final verticalMatches = {
      '1-7': '25-bayrak',
      '7-13': '26-testi',
      '13-19': '27-el',
      '19-1': '28-canta',
      '2-8': '29-cicek',
      '8-14': '30-kadeh',
      '14-20': '31-makas',
      '20-2': '32-civciv',
      '3-9': '33-tabak',
      '9-15': '34-supurge',
      '15-21': '35-nota',
      '21-3': '36-ay',
      '4-10': '37-yaprak',
      '10-16': '38-cicek',
      '16-22': '39-anahtar',
      '22-4': '40-gemi',
      '5-11': '41-saat',
      '11-17': '42-simsek',
      '17-23': '43-uzum',
      '23-5': '44-bozuk-para',
      '6-12': '45-balik',
      '12-18': '46-fincan',
      '18-24': '47-yuzuk',
      '24-6': '48-sihirli-lamba',
    };

    _matches.clear();
    for (var i = 0; i < _randomOrder.length; i++) {
      if (i % 6 < 5) {
        String key = '${_randomOrder[i] + 1}-${_randomOrder[i + 1] + 1}';
        if (horizontalMatches.containsKey(key)) {
          _matches[key] = horizontalMatches[key]!;
        }
      }
      if (i < 18) {
        String key = '${_randomOrder[i] + 1}-${_randomOrder[i + 6] + 1}';
        if (verticalMatches.containsKey(key)) {
          _matches[key] = verticalMatches[key]!;
        }
      }
    }

    notifyListeners();
  }

  Map<String, String> get matches => _matches;
}
