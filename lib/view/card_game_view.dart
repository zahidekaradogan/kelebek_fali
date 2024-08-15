import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/card_game_controller.dart';

class CardGameView extends StatefulWidget {
  @override
  _CardGameViewState createState() => _CardGameViewState();
}

class _CardGameViewState extends State<CardGameView> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(24, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300), // Her kart için animasyon süresi
      );
    });

    _animations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _startSequentialAnimations();
  }

  Future<void> _startSequentialAnimations() async {
    for (var i = 0; i < _animationControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100)); // Kartlar arasındaki gecikme
      _animationControllers[i].forward();
    }
    context.read<CardGameController>().checkMatches(); // Kartlar açıldıktan sonra eşleşmeleri kontrol et
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final controller = context.watch<CardGameController>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Image.asset(
            'assets/images/object/kelebek_fali_logo.png',
            height: 40,
            width: 40,
            fit: BoxFit.contain,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
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
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, // 6x4 grid
                  mainAxisSpacing: 4.0, // Kartlar arasındaki dikey boşluk
                  crossAxisSpacing: 4.0, // Kartlar arasındaki yatay boşluk
                  childAspectRatio: 1, // Kartların kare oranı
                ),
                itemCount: 24,
                itemBuilder: (context, index) {
                  final card = context.watch<CardGameController>().cards[index];
                  return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animations[index].value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0), // Köşe yuvarlama
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0), // Resmin köşeleri yuvarlak
                            child: Image.asset(card.imagePath, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // Kelebek Falına Başla butonu
          if (!controller.hasStarted)
            Padding(
              padding: const EdgeInsets.only(top: 16.0), // Kartların hemen altında buton için boşluk
              child: ElevatedButton(
                onPressed: () {
                  controller.startGame();
                   _initializeAnimations(); // Animasyonları sıfırla
                  _startSequentialAnimations();
                },
                child: const Text('Kelebek Falına Başla'),
              ),
            ),
        if (controller.hasStarted)
          // Kartların altındaki sabit Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Eşleşen Kart Sayısı: ${context.watch<CardGameController>().matchCount}'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<CardGameController>().resetGame();
                    _initializeAnimations(); // Resetlendiğinde animasyonları yeniden başlat
                  },
                  child: const Text('Kartları Yeniden Aç'),
                ),
              ],
            ),
          ),
          // Eşleşmeler Listesi (kartlar açıldıktan sonra görünür)
          if (context.watch<CardGameController>().hasStarted)
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
