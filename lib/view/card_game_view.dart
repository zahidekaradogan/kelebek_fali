import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/card_game_controller.dart';

class CardGameView extends StatefulWidget {
  const CardGameView({super.key});

  @override
  _CardGameViewState createState() => _CardGameViewState();
}

class _CardGameViewState extends State<CardGameView> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;
  final List<GlobalKey> _cardKeys = List.generate(24, (index) => GlobalKey()); // GlobalKeys to track card positions
  final List<Offset> _cardPositions = List.generate(24, (index) => Offset.zero); // Store positions of cards
  final List<Size> _cardSizes = List.generate(24, (index) => Size.zero); // Store sizes of cards
  final List<OverlayEntry> _overlayEntries = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(24, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
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
      await Future.delayed(const Duration(milliseconds: 300));
      _animationControllers[i].forward();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardPositions());
    context.read<CardGameController>().checkMatches();
  }

  void _updateCardPositions() {
    for (int i = 0; i < _cardKeys.length; i++) {
      final renderBox = _cardKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;
        _cardPositions[i] = position;
        _cardSizes[i] = size;
      }
    }
    _drawOverlayCircles();
  }

  void _drawOverlayCircles() {
    // Clear existing overlays
    for (var entry in _overlayEntries) {
      entry.remove();
    }
    _overlayEntries.clear();

    final controller = context.read<CardGameController>();

    for (var pair in controller.matchedCardIndices) {
      final firstCardPosition = _cardPositions[pair.first];
      final secondCardPosition = _cardPositions[pair.second];
      final firstCardSize = _cardSizes[pair.first];
      final secondCardSize = _cardSizes[pair.second];

      // Hesaplanan kesişim merkezi
      final center = Offset(
        (firstCardPosition.dx + firstCardSize.width / 2 + secondCardPosition.dx + secondCardSize.width / 2) / 2,
        (firstCardPosition.dy + firstCardSize.height / 2 + secondCardPosition.dy + secondCardSize.height / 2) / 2,
      );

      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: center.dx - 20, // Çemberin yarıçapı kadar sola kaydır
          top: center.dy - 20,  // Çemberin yarıçapı kadar yukarı kaydır
          child: CustomPaint(
            painter: MatchCirclePainter(Offset(20, 20), 20.0), // Çemberin merkezi ve yarıçapı
            size: Size(40, 40), // Çember boyutu
          ),
        ),
      );

      _overlayEntries.add(overlayEntry);
      Overlay.of(context).insert(overlayEntry);
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    for (var entry in _overlayEntries) {
      entry.remove();
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
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: SizedBox(
            width: 100,
            height: 40,
            child: Image.asset(
              'assets/images/object/kelebek_fali_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.home,
              size: 28,
              color: const Color(0xFF13A79D),
            ),
            onPressed: () {
              // Anasayfaya yönlendirme fonksiyonu
              // Henüz implement edilmedi
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 500,
                      ),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 1,
                        ),
                        itemCount: 24,
                        itemBuilder: (context, index) {
                          final card = context.watch<CardGameController>().cards[index];

                          return Stack(
                            children: [
                              AnimatedBuilder(
                                animation: _animations[index],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _animations[index].value,
                                    child: Container(
                                      key: _cardKeys[index], // Assign GlobalKey to each card
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.50),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(10, 10),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.asset(card.imagePath, fit: BoxFit.cover),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (!controller.hasStarted)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13A79D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          controller.startGame();
                          _initializeAnimations();
                          _startSequentialAnimations();
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Icon(Icons.play_arrow),
                              SizedBox(width: 8),
                              Text(
                                'Kelebek Falına Başla',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (controller.hasStarted)
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Eşleşen Kart Sayısı: ${context.watch<CardGameController>().matchCount}'),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13A79D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        context.read<CardGameController>().resetGame();
                        _initializeAnimations();
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.refresh),
                            SizedBox(width: 8),
                            Text(
                              'Kartları Yeniden Aç',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (controller.hasStarted)
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<CardGameController>().matches.length,
                itemBuilder: (context, index) {
                  final match = context.watch<CardGameController>().matches.entries.toList()[index];
                  return ListTile(
                    leading: Image.asset(
                      match.value['image']!,
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.contain,
                    ),
                    title: Text(
                      match.value['title']!,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      match.value['description']!,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// Çember çizen painter
class MatchCirclePainter extends CustomPainter {
  final Offset center;
  final double radius;

  MatchCirclePainter(this.center, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(radius, radius), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
