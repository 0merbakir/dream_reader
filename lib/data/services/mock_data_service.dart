import 'dart:math';

class MockDataService {
  static List<Map<String, dynamic>> getMockDreams() {
    final now = DateTime.now();

    // 8 English Dreams
    final enDreams = [
      {
        'text':
            'I was floating in a void of azure light, feeling the weight of eternity lifting.',
        'analysis': {
          'interpretation':
              'You are seeking clarity in the unknown, detaching from earthly burdens.',
          'psychological_insight':
              'This reflects a desire for ego dissolution and spiritual expansion.',
          'dream_guidance':
              'Embrace the silence rather than filling it with noise.',
          'archetypal_theme':
              'A glowing azure void with floating geometric shapes',
          'detected_language': 'en'
        }
      },
      {
        'text': 'A golden thread pulled me through a dark labyrinth.',
        'analysis': {
          'interpretation':
              'Your path is guided by a higher purpose even in confusion.',
          'psychological_insight':
              'The thread represents the Self guiding the ego through the shadow.',
          'dream_guidance': 'Trust your intuition, it knows the way out.',
          'archetypal_theme':
              'A golden thread winding through a dark stone labyrinth',
          'detected_language': 'en'
        }
      },
      {
        'text': 'I saw a clockwork city in the clouds, gears turning slowly.',
        'analysis': {
          'interpretation':
              'You perceive the intricate mechanisms of reality working in harmony.',
          'psychological_insight':
              'An ordered cosmos signifies a structured and logical mind seeking balance.',
          'dream_guidance': 'Align your daily routine with your greater goals.',
          'archetypal_theme':
              'Steampunk city floating in clouds with giant gears',
          'detected_language': 'en'
        }
      },
      {
        'text': 'The ocean was still as a mirror, reflecting a double moon.',
        'analysis': {
          'interpretation':
              'Your emotions have reached a state of perfect balance and reflection.',
          'psychological_insight':
              'The double moon suggests a union of conscious and unconscious aspects.',
          'dream_guidance': 'Look inward, your reflection holds the answer.',
          'archetypal_theme': 'Mirror-like ocean reflecting a huge double moon',
          'detected_language': 'en'
        }
      },
      {
        'text': 'I was a bird flying over a neon forest at night.',
        'analysis': {
          'interpretation':
              'You yearn for freedom from the artificial constructs of modern life.',
          'psychological_insight':
              'Flight indicates a desire to transcend current limitations.',
          'dream_guidance':
              'Gain perspective by detaching from the immediate situation.',
          'archetypal_theme':
              'Neon bioluminescent forest seen from above as a bird',
          'detected_language': 'en'
        }
      },
      {
        'text': 'Walking through walls of liquid glass.',
        'analysis': {
          'interpretation': 'Barriers in your life are an illusion.',
          'psychological_insight':
              'You are realizing the permeability of your defined limits.',
          'dream_guidance':
              'Move forward with confidence; obstacles will yield.',
          'archetypal_theme': 'Person walking through ripples of liquid glass',
          'detected_language': 'en'
        }
      },
      {
        'text': 'A lion made of fire guarded the gate.',
        'analysis': {
          'interpretation':
              'A powerful transformation awaits if you can face your fear.',
          'psychological_insight':
              'The lion represents raw solar energy and courage.',
          'dream_guidance': 'Do not back down from the challenge ahead.',
          'archetypal_theme':
              'A majestic lion made of fire standing before a gate',
          'detected_language': 'en'
        }
      },
      {
        'text': 'The library of infinite books with blank pages.',
        'analysis': {
          'interpretation': 'Your future is unwritten and limitless.',
          'psychological_insight':
              'The blank pages symbolize potentiality and the power of choice.',
          'dream_guidance': 'Start writing your own story today.',
          'archetypal_theme':
              'Endless library shelves with glowing blank white books',
          'detected_language': 'en'
        }
      },
    ];

    // 7 Turkish Dreams
    final trDreams = [
      {
        'text': 'Mavi bir ışık boşluğunda süzülüyordum.',
        'analysis': {
          'interpretation': 'Bilinmeze karşı bir netlik arayışındasınız.',
          'psychological_insight': 'Bu, ruhsal genişleme arzusunu yansıtır.',
          'dream_guidance':
              'Sessizliği gürültüyle doldurmak yerine onu kucakla.',
          'archetypal_theme': 'Floating in a void of blue light, surreal',
          'detected_language': 'tr'
        }
      },
      {
        'text': 'Altın bir ip beni karanlık bir labirentten çıkardı.',
        'analysis': {
          'interpretation':
              'Karmaşa içinde bile yüksek bir amaç tarafından yönlendiriliyorsunuz.',
          'psychological_insight':
              'İp, gölge içindeki egoya rehberlik eden Benliği temsil eder.',
          'dream_guidance': 'Sezgine güven, çıkış yolunu o biliyor.',
          'archetypal_theme': 'A golden thread in a dark labyrinth',
          'detected_language': 'tr'
        }
      },
      {
        'text': 'Gökyüzünde çarklardan oluşan bir şehir gördüm.',
        'analysis': {
          'interpretation':
              'Gerçekliğin karmaşık mekanizmalarını uyum içinde algılıyorsunuz.',
          'psychological_insight':
              'Düzenli kozmos, denge arayan mantıklı bir zihni işaret eder.',
          'dream_guidance': 'Günlük rutinini büyük hedeflerinle hizala.',
          'archetypal_theme': 'Clockwork city in the sky',
          'detected_language': 'tr'
        }
      },
      {
        'text': 'Deniz ayna gibi durgundu, çift ayı yansıtıyordu.',
        'analysis': {
          'interpretation':
              'Duygularınız mükemmel bir denge ve yansıma durumuna ulaştı.',
          'psychological_insight':
              'Çift ay, bilinç ve bilinçdışının birleşimini önerir.',
          'dream_guidance': 'İçine bak, yansıman cevabı tutuyor.',
          'archetypal_theme': 'Calm ocean reflecting two moons',
          'detected_language': 'tr'
        }
      },
      {
        'text': 'Gece neon bir ormanın üzerinde uçan bir kuştum.',
        'analysis': {
          'interpretation':
              'Modern yaşamın yapay kurgularından özgürleşmek istiyorsunuz.',
          'psychological_insight':
              'Uçuş, mevcut sınırları aşma arzusunu gösterir.',
          'dream_guidance': 'Durumdan uzaklaşarak perspektif kazan.',
          'archetypal_theme': 'Flying over a neon forest at night',
          'detected_language': 'tr'
        }
      },
      {
        'text': 'Sıvı camdan duvarların içinden geçtim.',
        'analysis': {
          'interpretation': 'Hayatındaki engeller bir ilüzyon.',
          'psychological_insight':
              'Sınırlarının geçirgenliğini fark ediyorsun.',
          'dream_guidance': 'Güvenle ilerle; engeller yol verecek.',
          'archetypal_theme': 'Walking through liquid glass walls',
          'detected_language': 'tr'
        }
      },
      {
        'text': 'Ateşten bir aslan kapıyı bekliyordu.',
        'analysis': {
          'interpretation':
              'Korkunla yüzleşirsen büyük bir dönüşüm seni bekliyor.',
          'psychological_insight':
              'Aslan saf güneş enerjisini ve cesareti temsil eder.',
          'dream_guidance': 'Önündeki zorluktan geri adım atma.',
          'archetypal_theme': 'Lion made of fire guarding a gate',
          'detected_language': 'tr'
        }
      }
    ];

    List<Map<String, dynamic>> allDreams = [...enDreams, ...trDreams];

    // Image URLs (cycled)
    const imageUrls = [
      "https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800&q=80",
      "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=800&q=80",
      "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=800&q=80",
      "https://images.unsplash.com/photo-1506318137071-a8bcbf675b27?w=800&q=80",
      "https://images.unsplash.com/photo-1516339901601-2e1b62dc0c45?w=800&q=80",
      "https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&q=80",
      "https://images.unsplash.com/photo-1502481851512-e9e2529bfbf9?w=800&q=80",
      "https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?w=800&q=80",
      "https://images.unsplash.com/photo-1504333638930-c8787321eee0?w=800&q=80",
      "https://images.unsplash.com/photo-1590523277543-a94d2e4eb00b?w=800&q=80",
    ];

    return List.generate(allDreams.length, (index) {
      final dream = allDreams[index];
      final random = Random();
      return {
        'id': 'mock_$index',
        'text': dream['text'],
        'date': now.subtract(Duration(days: index)).toIso8601String(),
        'imageUrl': imageUrls[index % imageUrls.length],
        'analysis': dream['analysis'],
        'vibrationLevel': 5 + random.nextInt(6), // 5-10
        'archetypes': {
          "The Shadow": random.nextDouble(),
          "The Sage": random.nextDouble(),
          "The Traveler": random.nextDouble(),
          "The Guardian": random.nextDouble(),
          "The Eternal": random.nextDouble(),
        },
      };
    });
  }
}
