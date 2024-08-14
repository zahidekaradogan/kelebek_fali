// lib/view/card_game_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/card_game_controller.dart';

class CardGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F5F8),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            'assets/images/object/fc_logos1.png',
            height: 95,
            width: 600,
          ),
        ),
        actions: <Widget>[
          IconButton(
             icon: Icon(
              Icons.home,
              size: 28,
              color: Colors.black, 
            ),
            onPressed: () {
              // Anasayfaya yönlendirme fonksiyonu
              // Henüz implement edilmedi
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 6, // 6x4 grid
    mainAxisSpacing: 2.0, // Kartlar arasındaki dikey boşluk (daha yakın)
    crossAxisSpacing: 2.0, // Kartlar arasındaki yatay boşluk (daha yakın)
    childAspectRatio: 1, // Kartların kare oranı
  ),
  itemCount: 24,
  itemBuilder: (context, index) {
    final card = context.watch<CardGameController>().cards[index];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0), // Köşe yuvarlama
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(2, 4), // Gölge efekti
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0), // Resmin köşeleri yuvarlak
        child: Image.asset(card.imagePath, fit: BoxFit.cover),
      ),
    );
  },
),
          ),
          // Kartların altındaki Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Açılan Kart Sayısı: 0'),
                    Text('Eşleşen Kart Sayısı: ${context.watch<CardGameController>().matchCount}'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CardGameController>().resetGame();
                  },
                  child: const Text('Kartları Yeniden Aç'),
                ),
              ],
            ),
          ),
          // Kelebek Falına Başla butonu
          if (!context.watch<CardGameController>().hasStarted)
            ElevatedButton(
              onPressed: () {
                context.read<CardGameController>().startGame();
              },
              child: const Text('Kelebek Falına Başla'),
            ),
          // Eşleşmeler Listesi
          Expanded(
            child: ListView.builder(
              itemCount: context.watch<CardGameController>().matches.length,
              itemBuilder: (context, index) {
                final match = context.watch<CardGameController>().matches.entries.toList()[index];
                return ListTile(
                  leading: Image.asset('assets/images/object/${match.value}.png'),
                  title: Text(match.value),
                  subtitle: Text('Description for ${match.value}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
