import 'dart:math';
import 'package:flutter/material.dart';
import '../model/card_model.dart';

class CardGameController extends ChangeNotifier {
  List<CardModel> _cards = [];
  List<int> _randomOrder = [];
  int matchCount = 0;
  final Map<String, Map<String, String>> _matches = {}; 
  bool hasStarted = false;
  bool animationsCompleted = false;

  // Eşleşen kartların indekslerini tutacak liste
  final List<Pair<int, int>> matchedCardIndices = [];

  CardGameController() {
    _initializeGame();
  }

  List<CardModel> get cards => _cards;
  List<int> get randomOrder => _randomOrder;
  Map<String, Map<String, String>> get matches => _matches;

  void _initializeGame() {
    _cards = List.generate(24, (index) => CardModel(
      imagePath: 'assets/images/cards/back_card.png',
      objectDescription: 'Back of the card',
    ));
    notifyListeners();
  }

  void _shuffleCards() {
    final random = Random();
    _randomOrder = List.generate(_cards.length, (index) => index)..shuffle(random);

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
    animationsCompleted = false;
    _shuffleCards();
    matchCount = 0;
    _matches.clear();
    notifyListeners();
  }

  void resetGame() {
    _shuffleCards();
    hasStarted = true;
    matchCount = 0;
    animationsCompleted = false;
    notifyListeners();
  }


  void checkMatches() {
    final horizontalMatches = {
  '1-2': {
    'image': 'assets/images/object/1-tac.png',
    'title': 'Tac',
    'description': 'Sürpriz'
  },
  '2-3': {
    'image': 'assets/images/object/2-kus.png',
    'title': 'Kuş',
    'description': 'Sakin Hayat'
  },
  '3-4': {
    'image': 'assets/images/object/3-ok.png',
    'title': 'Ok',
    'description': 'Aşk'
  },
  '4-5': {
    'image': 'assets/images/object/4-kalp.png',
    'title': 'Kalp',
    'description': 'Dileğin Olacak'
  },
  '5-6': {
    'image': 'assets/images/object/5-mum.png',
    'title': 'Mum',
    'description': 'Umut'
  },
  '6-1': {
    'image': 'assets/images/object/6-elbise.png',
    'title': 'Elbise',
    'description': 'Yenilik'
  },
  '7-8': {
    'image': 'assets/images/object/7-can.png',
    'title': 'Çan',
    'description': 'Haber'
  },
  '8-9': {
    'image': 'assets/images/object/8-nal.png',
    'title': 'Nal',
    'description': 'Şans'
  },
  '9-10': {
    'image': 'assets/images/object/9-gunes.png',
    'title': 'Güneş',
    'description': 'Mutluluk'
  },
  '10-11': {
    'image': 'assets/images/object/10-masa.png',
    'title': 'Masa',
    'description': 'Yeni Gelişme'
  },
  '11-12': {
    'image': 'assets/images/object/11-kilit.png',
    'title': 'Kilit',
    'description': 'Karışıklık'
  },
  '12-7': {
    'image': 'assets/images/object/12-inci.png',
    'title': 'İnci',
    'description': 'Değişiklik'
  },
  '13-14': {
    'image': 'assets/images/object/13-balon.png',
    'title': 'Balon',
    'description': 'Yeni Ortam'
  },
  '14-15': {
    'image': 'assets/images/object/14-yilan.png',
    'title': 'Yılan',
    'description': 'Yol'
  },
  '15-16': {
    'image': 'assets/images/object/15-kelebek.png',
    'title': 'Kelebek',
    'description': 'Hayırlı Yol'
  },
  '16-17': {
    'image': 'assets/images/object/16-mektup.png',
    'title': 'Mektup',
    'description': 'Haber'
  },
  '17-18': {
    'image': 'assets/images/object/17-kitap.png',
    'title': 'Kitap',
    'description': 'İş'
  },
  '18-13': {
    'image': 'assets/images/object/18-dis-fircasi.png',
    'title': 'Diş Fırçası',
    'description': 'Sinirleneceksin'
  },
  '19-20': {
    'image': 'assets/images/object/19-kalpli-ok.png',
    'title': 'Kalpli Ok',
    'description': 'Karşılıklı Aşk'
  },
  '20-21': {
    'image': 'assets/images/object/20-ev.png',
    'title': 'Ev',
    'description': 'Dışarda Bir Ev'
  },
  '21-22': {
    'image': 'assets/images/object/21-bardak.png',
    'title': 'Bardak',
    'description': 'Hastalık'
  },
  '22-23': {
    'image': 'assets/images/object/22-terazi.png',
    'title': 'Terazi',
    'description': 'Denge'
  },
  '23-24': {
    'image': 'assets/images/object/23-para.png',
    'title': 'Para',
    'description': 'Bolluk'
  },
  '24-19': {
    'image': 'assets/images/object/24-kilic.png',
    'title': 'Kılıç',
    'description': 'İntikam'
  },
};
final verticalMatches = {
  '1-7': {
    'image': 'assets/images/object/25-bayrak.png',
    'title': 'Bayrak',
    'description': 'Devlet Kapısı'
  },
  '7-13': {
    'image': 'assets/images/object/26-testi.png',
    'title': 'Testi',
    'description': 'Yalan'
  },
  '13-19': {
    'image': 'assets/images/object/27-el.png',
    'title': 'El',
    'description': 'Görüşme'
  },
  '19-1': {
    'image': 'assets/images/object/28-canta.png',
    'title': 'Çanta',
    'description': 'Ayrılık'
  },
  '2-8': {
    'image': 'assets/images/object/29-cicek.png',
    'title': 'Çiçek',
    'description': 'Buluşma'
  },
  '8-14': {
    'image': 'assets/images/object/30-kadeh.png',
    'title': 'Kadeh',
    'description': 'Eğlence'
  },
  '14-20': {
    'image': 'assets/images/object/31-makas.png',
    'title': 'Makas',
    'description': 'Yeni Bir Başlangıç'
  },
  '20-2': {
    'image': 'assets/images/object/32-civciv.png',
    'title': 'Civciv',
    'description': 'Beklenmeyen Para'
  },
  '3-9': {
    'image': 'assets/images/object/33-tabak.png',
    'title': 'Tabak',
    'description': 'Yemek'
  },
  '9-15': {
    'image': 'assets/images/object/34-supurge.png',
    'title': 'Süpürge',
    'description': 'Kavga'
  },
  '15-21': {
    'image': 'assets/images/object/35-nota.png',
    'title': 'Nota',
    'description': 'Mutluluk'
  },
  '21-3': {
    'image': 'assets/images/object/36-ay.png',
    'title': 'Ay',
    'description': 'Hafta Başı'
  },
  '4-10': {
    'image': 'assets/images/object/37-yaprak.png',
    'title': 'Yaprak',
    'description': 'Arkadaş, Akraba'
  },
  '10-16': {
    'image': 'assets/images/object/38-cicek.png',
    'title': 'Gül',
    'description': 'Buluşma'
  },
  '16-22': {
    'image': 'assets/images/object/39-anahtar.png',
    'title': 'Anahtar',
    'description': 'Kontrol Elinde'
  },
  '22-4': {
    'image': 'assets/images/object/40-gemi.png',
    'title': 'Gemi',
    'description': 'Uzun Zaman Görmediğin Biri'
  },
  '5-11': {
    'image': 'assets/images/object/41-saat.png',
    'title': 'Zaman',
    'description': 'Zamanı Gelen'
  },
  '11-17': {
    'image': 'assets/images/object/42-simsek.png',
    'title': 'Şimşek',
    'description': 'Kötü Haber'
  },
  '17-23': {
    'image': 'assets/images/object/43-uzum.png',
    'title': 'Üzüm',
    'description': 'Kısmet'
  },
  '23-5': {
    'image': 'assets/images/object/44-bozuk-para.png',
    'title': 'Bozuk Para',
    'description': 'Küçük Para'
  },
  '6-12': {
    'image': 'assets/images/object/45-balik.png',
    'title': 'Balık',
    'description': 'Başka Birinin Olayı'
  },
  '12-18': {
    'image': 'assets/images/object/46-fincan.png',
    'title': 'Fincan',
    'description': 'Bir Davet'
  },
  '18-24': {
    'image': 'assets/images/object/47-yuzuk.png',
    'title': 'Yüzük',
    'description': 'Kutlama'
  },
  '24-6': {
    'image': 'assets/images/object/48-sihirli-lamba.png',
    'title': 'Sihirli Lamba',
    'description': 'Dileğin Gerçekleşecek'
  },
};


 _matches.clear();
    matchedCardIndices.clear();

    for (var i = 0; i < _randomOrder.length; i++) {
      if (i % 6 < 5) {
        String key = '${_randomOrder[i] + 1}-${_randomOrder[i + 1] + 1}';
        if (horizontalMatches.containsKey(key)) {
          _matches[key] = horizontalMatches[key]!;
          matchedCardIndices.add(Pair(i, i + 1)); // Eşleşen indeksleri ekle
          matchCount++;
        }
      }
      if (i < 18) {
        String key = '${_randomOrder[i] + 1}-${_randomOrder[i + 6] + 1}';
        if (verticalMatches.containsKey(key)) {
          _matches[key] = verticalMatches[key]!;
          matchedCardIndices.add(Pair(i, i + 6)); // Eşleşen indeksleri ekle
          matchCount++;
        }
      }
    }

    notifyListeners();  
  }

  bool isCardMatched(int index) {
    for (var key in _matches.keys) {
      var numbers = key.split('-').map(int.parse).toList();
      if (_randomOrder[index] + 1 == numbers[0] || _randomOrder[index] + 1 == numbers[1]) {
        return true;
      }
    }
    return false;
  }
}

// Basit bir çift sınıfı
class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);
}