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
    matchedCardIndices.clear();
    matchCount = 0;
    _matches.clear();
    _shuffleCards();
    hasStarted = true;
    animationsCompleted = false;
    notifyListeners();
  }



  void checkMatches(BuildContext context) {
  final horizontalMatches = {
    '1-2': {
      'image': 'assets/images/object/1-tac.png',
      'title': 'Tac',
      'description': 'Başına taç takılacak bir döneme giriyorsun. Hayatında seni onurlandıracak, saygınlığını artıracak sürprizlerle karşılaşacaksın. Bu sürpriz, uzun zamandır beklediğin bir başarı olabilir. Bu dönemde dikkat etmen gereken, alçakgönüllü kalmak ve şansını iyi değerlendirmektir.'
    },
    '2-3': {
      'image': 'assets/images/object/2-kus.png',
      'title': 'Kuş',
      'description': 'Sakin bir hayat seni bekliyor. Kuş, özgürlüğün ve huzurun sembolüdür. Yakında hayatındaki stres ve karmaşadan uzaklaşıp, ruhunu dinlendireceğin, sakin ve huzurlu bir döneme gireceksin. Bu zaman diliminde doğa ile daha fazla iç içe olman, zihinsel ve fiziksel sağlığın için faydalı olacaktır.'
    },
    '3-4': {
      'image': 'assets/images/object/3-ok.png',
      'title': 'Ok',
      'description': 'Aşk hayatında hedefi tam on ikiden vuracaksın. Ok, sevginin ve tutkunun sembolüdür. Yeni bir aşk kapını çalabilir ya da mevcut ilişkin daha da derinleşebilir. Bu dönemde duygularını açıkça ifade etmekten çekinme, çünkü kalbine giden yol, doğruluk ve dürüstlükten geçer.'
    },
    '4-5': {
      'image': 'assets/images/object/4-kalp.png',
      'title': 'Kalp',
      'description': 'Dileğin gerçek olacak. Kalp, sevginin, bağlılığın ve duygusal arzuların sembolüdür. Uzun zamandır içinde taşıdığın bir dileğin, bir hayalin, nihayet gerçek olabilir. Bu dileğin gerçekleşmesi, sana büyük bir mutluluk ve huzur getirecek.'
    },
    '5-6': {
      'image': 'assets/images/object/5-mum.png',
      'title': 'Mum',
      'description': 'Umut ışığı her zaman yanar. Mum, karanlık zamanlarda bile umut etmenin ve ışığı takip etmenin önemini hatırlatır. Yakın gelecekte seni aydınlatacak yeni bir umut doğacak. Bu umut, belki bir fırsat ya da destekleyici bir kişi olarak karşına çıkabilir.'
    },
    '6-1': {
      'image': 'assets/images/object/6-elbise.png',
      'title': 'Elbise',
      'description': 'Hayatında büyük bir yenilik var. Elbise, değişimin ve yenilenmenin sembolüdür. Yakın zamanda hayatında önemli bir değişiklik olabilir; bu, bir iş değişikliği, taşınma ya da yeni bir ilişki olabilir. Bu yenilik, hayatına taze bir nefes getirecek.'
    },
    '7-8': {
      'image': 'assets/images/object/7-can.png',
      'title': 'Çan',
      'description': 'Haber var! Çan, yaklaşan bir haberin, duyurunun ya da önemli bir gelişmenin habercisidir. Bu haber seni heyecanlandırabilir, çünkü beklenmedik ve olumlu bir gelişme olacak. Kulağını iyi aç, çünkü bu haber yakında gelecek!'
    },
    '8-9': {
      'image': 'assets/images/object/8-nal.png',
      'title': 'Nal',
      'description': 'Şans kapında! Nal, şansın ve iyi talihin sembolüdür. Hayatında beklenmedik bir şansın seni bulacağı bir dönemdesin. Bu şans, finansal bir kazanç, işte bir terfi ya da özel hayatında güzel bir gelişme olabilir.'
    },
    '9-10': {
      'image': 'assets/images/object/9-gunes.png',
      'title': 'Güneş',
      'description': 'Mutluluk dolu bir dönem seni bekliyor. Güneş, ışığı ve enerjiyi temsil eder; hayatına sıcaklık ve canlılık getirecek bir olayla karşılaşacaksın. Bu dönemde, çevrende pozitif enerji yayan insanlar olacak ve mutluluğun artacak.'
    },
    '10-11': {
      'image': 'assets/images/object/10-masa.png',
      'title': 'Masa',
      'description': 'Yeni bir gelişme yolda. Masa, planların ve düşüncelerin hayat bulacağı bir dönemi işaret eder. Yakında hayatında yeni bir gelişme olacak; bu bir iş teklifi, bir proje başlangıcı ya da kişisel bir başarı olabilir. Hazır ol, çünkü bu gelişme hayatını dönüştürecek.'
    },
    '11-12': {
      'image': 'assets/images/object/11-kilit.png',
      'title': 'Kilit',
      'description': 'Karışıklık ve belirsizlik. Kilit, çözülmesi gereken zorlukları ve gizemleri temsil eder. Hayatında bazı karışıklıklar ve belirsizlikler olabilir; bu durum, seni düşündürse de sonunda bir çıkış yolu bulacaksın. Sabırlı ol, çünkü anahtarı bulmak zaman alabilir.'
    },
    '12-7': {
      'image': 'assets/images/object/12-inci.png',
      'title': 'İnci',
      'description': 'Hayatında önemli bir değişiklik var. İnci, nadir bulunan ve değerli olanı temsil eder. Yakında hayatında değerli bir değişiklik olacak; bu, ruhsal bir gelişim, içsel bir aydınlanma ya da beklenmedik bir fırsat olabilir. Bu değişiklik seni daha da olgunlaştıracak.'
    },
    '13-14': {
      'image': 'assets/images/object/13-balon.png',
      'title': 'Balon',
      'description': 'Yeni bir ortam seni bekliyor. Balon, yükselmenin ve yeni başlangıçların habercisidir. Yakın zamanda sosyal çevren değişebilir ya da yeni bir ortama katılabilirsin. Bu ortam, sana yeni fırsatlar ve dostluklar getirecek.'
    },
    '14-15': {
      'image': 'assets/images/object/14-yilan.png',
      'title': 'Yılan',
      'description': 'Uzun ve zorlu bir yolculuk. Yılan, uzun bir yolun ve bu yolda karşılaşılacak zorlukların sembolüdür. Önünde uzun bir yolculuk var; bu, fiziksel bir seyahat olabileceği gibi, zihinsel ya da duygusal bir süreç de olabilir. Bu yolculuk seni güçlendirecek ve olgunlaştıracak.'
    },
    '15-16': {
      'image': 'assets/images/object/15-kelebek.png',
      'title': 'Kelebek',
      'description': 'Hayırlı bir yol açılıyor. Kelebek, dönüşümün ve yeniden doğuşun sembolüdür. Hayatında önemli bir değişim kapıda; bu değişim, seni daha iyi bir konuma getirecek. Hayırlı bir yolculuğa çıkabilir ya da hayatında olumlu bir dönüşüm yaşayabilirsin.'
    },
    '16-17': {
      'image': 'assets/images/object/16-mektup.png',
      'title': 'Mektup',
      'description': 'Yakında bir haber alacaksın. Mektup, beklenen ya da beklenmeyen bir haberin işaretidir. Bu haber, seni sevindirebilir ya da düşündürebilir. Gelen bilgilere dikkat et, çünkü hayatını değiştirebilir.'
    },
    '17-18': {
      'image': 'assets/images/object/17-kitap.png',
      'title': 'Kitap',
      'description': 'İşle ilgili önemli gelişmeler. Kitap, bilgi, öğrenme ve kariyerin sembolüdür. İş hayatında önemli bir ilerleme kaydedebilirsin; bu, yeni bir iş teklifi, terfi ya da kendi işini kurmak olabilir. Bu dönem, kariyerin için çok önemli olacak.'
    },
    '18-13': {
      'image': 'assets/images/object/18-dis-fircasi.png',
      'title': 'Diş Fırçası',
      'description': 'Seni sinirlendirecek bir durum. Diş fırçası, küçük ama rahatsız edici bir durumu işaret eder. Yakında seni sinirlendirecek bir olayla karşılaşabilirsin; bu, belki de basit bir yanlış anlama ya da küçük bir tartışma olabilir. Sakin kalmaya çalış.'
    },
    '19-20': {
      'image': 'assets/images/object/19-kalpli-ok.png',
      'title': 'Kalpli Ok',
      'description': 'Karşılıklı aşk kapıda. Kalpli ok, iki kalbin birbirine yöneldiğini ve tutkulu bir aşkın başladığını işaret eder. Eğer bir ilişkin varsa, bu dönem daha da derinleşebilir. Eğer bekarsan, kalbinin sahibini bulabilirsin.'
    },
    '20-21': {
      'image': 'assets/images/object/20-ev.png',
      'title': 'Ev',
      'description': 'Hayatında yeni bir düzen. Ev, güvenliğin ve huzurun sembolüdür. Dışarıda bir evle ilgili bir gelişme yaşayabilirsin; bu, taşınma, yeni bir ev alma ya da mevcut evinde değişiklikler yapma olabilir. Bu değişiklik, sana huzur ve mutluluk getirecek.'
    },
    '21-22': {
      'image': 'assets/images/object/21-bardak.png',
      'title': 'Bardak',
      'description': 'Sağlığınla ilgili dikkat etmen gereken bir dönem. Bardak, dolup taşan bir duygusal durumu ya da sağlıkla ilgili bir uyarıyı temsil eder. Yakın zamanda sağlığına daha fazla dikkat etmen gerekebilir; bu, bir hastalık ya da bir uyarı işareti olabilir.'
    },
    '22-23': {
      'image': 'assets/images/object/22-terazi.png',
      'title': 'Terazi',
      'description': 'Hayatında dengeyi bulacaksın. Terazi, adaletin ve dengenin sembolüdür. Hayatında dengeyi bulmak için çabaladığın bir dönemdesin. Bu dönemde, iç huzuru yakalayacak ve her şeyin yerli yerine oturduğunu hissedeceksin.'
    },
    '23-24': {
      'image': 'assets/images/object/23-para.png',
      'title': 'Para',
      'description': 'Bolluk ve bereket kapıda. Para, maddi bolluğun ve bereketin sembolüdür. Yakın zamanda finansal durumun iyileşebilir, beklenmedik bir kazanç elde edebilirsin. Bu dönemde, bereketli bir dönem yaşayacaksın.'
    },
    '24-19': {
      'image': 'assets/images/object/24-kilic.png',
      'title': 'Kılıç',
      'description': 'İntikam soğuk yenen bir yemektir. Kılıç, keskinliği ve kararlılığı temsil eder. Hayatında seni inciten birine karşı içinde taşıdığın öfkeyi dışa vurma isteği olabilir. Ancak, intikam almadan önce iki kere düşün; bu adımın sonuçlarını iyi tartmalısın.'
    },
  };
  final verticalMatches = {
    '1-7': {
      'image': 'assets/images/object/25-bayrak.png',
      'title': 'Bayrak',
      'description': 'Devlet kapısında bir işin olabilir. Bayrak, resmi kurumlarla ilgili gelişmeleri temsil eder. Yakın zamanda devletle ilgili bir başvurun sonuçlanabilir ya da resmi bir işin sonuçlanabilir. Bu gelişme, seni rahatlatacak ve geleceğinle ilgili önemli bir adım olacak.'
    },
    '7-13': {
      'image': 'assets/images/object/26-testi.png',
      'title': 'Testi',
      'description': 'Yalanlar ortaya çıkacak. Testi, saklanan sırların ve yalanların sembolüdür. Yakın zamanda çevrende dönen bir yalan ortaya çıkabilir. Bu durum, seni hem şaşırtabilir hem de düşündürebilir. Gerçeği öğrendiğinde, içsel olarak rahatlayacaksın.'
    },
    '13-19': {
      'image': 'assets/images/object/27-el.png',
      'title': 'El',
      'description': 'Bir görüşme gerçekleşecek. El, bir buluşmanın ya da yüz yüze yapılacak önemli bir görüşmenin habercisidir. Bu görüşme, iş hayatınla ilgili olabileceği gibi, özel hayatında da önemli bir rol oynayabilir. Bu buluşma, geleceğini etkileyebilir.'
    },
    '19-1': {
      'image': 'assets/images/object/28-canta.png',
      'title': 'Çanta',
      'description': 'Ayrılık kapıda. Çanta, bir yolculuğun ya da ayrılığın habercisidir. Yakında, sevdiğin biriyle yollarını ayırmak zorunda kalabilirsin. Bu ayrılık, geçici olabilir; ancak bu süreçte kendine ve duygularına dikkat etmen önemli.'
    },
    '2-8': {
      'image': 'assets/images/object/29-cicek.png',
      'title': 'Çiçek',
      'description': 'Bir buluşma seni bekliyor. Çiçek, taze bir başlangıcın ve güzel bir buluşmanın sembolüdür. Yakında, uzun zamandır beklediğin biriyle ya da sevdiğin biriyle güzel bir buluşma yaşayabilirsin. Bu buluşma, kalbini ısıtacak.'
    },
    '8-14': {
      'image': 'assets/images/object/30-kadeh.png',
      'title': 'Kadeh',
      'description': 'Eğlenceli bir döneme giriyorsun. Kadeh, kutlamaların ve eğlencenin habercisidir. Yakın zamanda sevdiklerinle birlikte keyifli vakit geçireceğin, kutlamaların olduğu bir dönem seni bekliyor. Bu dönemde, hayatın tadını çıkarmaya bak.'
    },
    '14-20': {
      'image': 'assets/images/object/31-makas.png',
      'title': 'Makas',
      'description': 'Yeni bir başlangıç yapma zamanı. Makas, bir şeyi bitirip yenisini başlatmanın sembolüdür. Hayatında yeni bir sayfa açma vakti geldi. Bu yeni başlangıç, seni özgürleştirecek ve hayatına yeni bir soluk getirecek.'
    },
    '20-2': {
      'image': 'assets/images/object/32-civciv.png',
      'title': 'Civciv',
      'description': 'Beklenmeyen bir para gelecek. Civciv, sürpriz bir kazancın habercisidir. Yakında, hiç beklemediğin bir yerden maddi bir kazanç elde edebilirsin. Bu para, seni hem sevindirecek hem de rahatlatacak.'
    },
    '3-9': {
      'image': 'assets/images/object/33-tabak.png',
      'title': 'Tabak',
      'description': 'Yemekle ilgili bir davet alacaksın. Tabak, bir davetin ya da özel bir buluşmanın habercisidir. Yakında bir yemekte, sevdiklerinle bir araya gelebilir ya da yeni biriyle tanışabilirsin. Bu davet, seni mutlu edecek.'
    },
    '9-15': {
      'image': 'assets/images/object/34-supurge.png',
      'title': 'Süpürge',
      'description': 'Bir kavga kapıda. Süpürge, eskiyi temizlemenin ve arınmanın sembolüdür. Ancak, bu temizlik süreci bazen kavgaları ve tartışmaları da beraberinde getirebilir. Yakında bir tartışma yaşayabilir, bu süreçten arınarak çıkabilirsin.'
    },
    '15-21': {
      'image': 'assets/images/object/35-nota.png',
      'title': 'Nota',
      'description': 'Mutluluk dolu bir haber alacaksın. Nota, sevinçli bir haberin ya da mutlu bir olayın sembolüdür. Yakında, seni sevindirecek bir haber alabilir ya da keyifli bir etkinliğe katılabilirsin. Bu mutluluk, hayatına renk katacak.'
    },
    '21-3': {
      'image': 'assets/images/object/36-ay.png',
      'title': 'Ay',
      'description': 'Hafta başında güzel bir gelişme. Ay, yeni bir haftanın ve tazelenmenin sembolüdür. Hafta başında, seni sevindirecek bir gelişme yaşanabilir. Bu gelişme, iş hayatında ya da kişisel yaşamında olabilir ve sana moral verecek.'
    },
    '4-10': {
      'image': 'assets/images/object/37-yaprak.png',
      'title': 'Yaprak',
      'description': 'Yakın çevrenden biriyle bağlantı. Yaprak, doğayı ve kökleri temsil eder. Yakında, arkadaşlarınızdan biri ya da bir akrabanızla önemli bir bağ kuracaksınız. Bu bağlantı, sizi mutlu edecek ve ilişkiyi derinleştirecek.'
    },
    '10-16': {
      'image': 'assets/images/object/38-cicek.png',
      'title': 'Gül',
      'description': 'Bir buluşma seni bekliyor. Gül, romantizmin ve özel bir buluşmanın habercisidir. Yakın zamanda sevdiğin biriyle romantik bir buluşma gerçekleştirebilirsin. Bu buluşma, kalbinin derinliklerine dokunacak.'
    },
    '16-22': {
      'image': 'assets/images/object/39-anahtar.png',
      'title': 'Anahtar',
      'description': 'Kontrol senin elinde. Anahtar, güç ve kontrolü temsil eder. Hayatında önemli bir konuda karar alma zamanı geldi. Bu süreçte, kontrolü elinde tutacak ve durumu kendi lehine çevireceksin.'
    },
    '22-4': {
      'image': 'assets/images/object/40-gemi.png',
      'title': 'Gemi',
      'description': 'Uzun zamandır görmediğin biriyle karşılaşma. Gemi, uzak mesafelerin ve özlemlerin sembolüdür. Yakın zamanda, uzun süredir görmediğin biriyle karşılaşabilir ya da yeniden bağlantı kurabilirsin. Bu buluşma, sana nostaljik duygular yaşatacak.'
    },
    '5-11': {
      'image': 'assets/images/object/41-saat.png',
      'title': 'Zaman',
      'description': 'Zamanı gelen bir şey var. Zaman, olgunlaşmanın ve doğru anın sembolüdür. Hayatında, zamanı gelmiş bir durum ya da bir fırsat var. Bu fırsatın değerlendirilmesi, seni ileriye taşıyacak.'
    },
    '11-17': {
      'image': 'assets/images/object/42-simsek.png',
      'title': 'Şimşek',
      'description': 'Kötü bir haber alabilirsin. Şimşek, aniden gelen şok edici bir gelişmenin habercisidir. Yakın zamanda beklenmedik bir kötü haber alabilirsin; ancak bu haber, seni güçlü kılacak ve zorlukların üstesinden gelmeni sağlayacak.'
    },
    '17-23': {
      'image': 'assets/images/object/43-uzum.png',
      'title': 'Üzüm',
      'description': 'Kısmetin açılıyor. Üzüm, bolluk ve bereketin sembolüdür. Yakında, kısmetin açılacak ve hayatında güzel gelişmeler yaşanacak. Bu kısmet, maddi ya da manevi olabilir ve seni mutlu edecek.'
    },
    '23-5': {
      'image': 'assets/images/object/44-bozuk-para.png',
      'title': 'Bozuk Para',
      'description': 'Küçük bir maddi kazanç elde edeceksin. Bozuk para, ufak ama değerli bir kazancın işaretidir. Yakında, küçük bir para kazanabilirsin; bu, bir jest, bir hediye ya da beklenmedik bir kazanç olabilir.'
    },
    '6-12': {
      'image': 'assets/images/object/45-balik.png',
      'title': 'Balık',
      'description': 'Başka birinin olayı seni etkileyecek. Balık, sezgilerin ve başkalarının hayatlarına duyulan ilgiyi temsil eder. Yakın zamanda, başka birinin yaşadığı bir olay, seni etkileyebilir ve düşündürebilir. Bu olaydan alacağın dersler, sana yol gösterecek.'
    },
    '12-18': {
      'image': 'assets/images/object/46-fincan.png',
      'title': 'Fincan',
      'description': 'Bir davet alacaksın. Fincan, bir buluşmanın ya da toplantının habercisidir. Yakında bir davet alabilir, sosyal bir etkinliğe katılabilirsin. Bu davet, sana keyifli anlar yaşatacak ve yeni bağlantılar kurmanı sağlayacak.'
    },
    '18-24': {
      'image': 'assets/images/object/47-yuzuk.png',
      'title': 'Yüzük',
      'description': 'Kutlama zamanı! Yüzük, birlikteliğin ve bağlılığın sembolüdür. Yakında bir kutlama yapabilir, özel bir anı taçlandırabilirsiniz. Bu kutlama, aşk hayatınızda ya da sosyal çevrenizde önemli bir rol oynayacak.'
    },
    '24-6': {
      'image': 'assets/images/object/48-sihirli-lamba.png',
      'title': 'Sihirli Lamba',
      'description': 'Dileğin gerçekleşecek. Sihirli lamba, hayallerin ve arzuların sembolüdür. Uzun zamandır beklediğin bir dileğin, nihayet gerçek olabilir. Bu gerçekleşme, hayatında büyük bir mutluluk yaratacak.'
    },
  };

  
    _matches.clear();
    matchedCardIndices.clear();
    matchCount = 0;  

    for (var i = 0; i < _randomOrder.length; i++) {
      if (i % 6 < 5) {
        String key = '${_randomOrder[i] + 1}-${_randomOrder[i + 1] + 1}';
        if (horizontalMatches.containsKey(key)) {
          _matches[key] = horizontalMatches[key]!;
          matchedCardIndices.add(Pair(i, i + 1));
          matchCount++;
        }
      }
      if (i < 18) {
        String key = '${_randomOrder[i] + 1}-${_randomOrder[i + 6] + 1}';
        if (verticalMatches.containsKey(key)) {
          _matches[key] = verticalMatches[key]!;
          matchedCardIndices.add(Pair(i, i + 6));
          matchCount++;
        }
      }
    }

    notifyListeners();

    // Eğer eşleşme yoksa bir Toast mesajı göster
    if (matchCount == 0) {
      _showNoMatchesToast(context);
    }
  }

  void _showNoMatchesToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          'Falınızda hiçbir eşleşme yok! Kısmetiniz başka bir güne kaldı.',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF13A79D),
        duration: Duration(seconds: 3),
      ),
    );
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

class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);
}