class LanguageService {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'settings_title': 'SACRED CONFIGURATIONS',
      'language_label': 'Language',
      'voice_label': 'The Guide\'s Voice',
      'premium_label': 'Mastery Level',
      'premium_subtitle': 'Unlock the Cosmic Archive',
      'test_premium': 'Test Premium Access',

      // Navigation
      'nav_record': 'RECORD',
      'nav_nebula': 'NEBULA',
      'nav_wisdom': 'WISDOM',
      'nav_soul': 'SOUL',

      // Messages
      'error_stars_misaligned':
          'The stars are misaligned, try your ritual again.',
      'success_ritual_complete': 'Your ritual is complete.',

      // Nebula
      'nebula_title': 'THE COSMIC ARCHIVE',
      'filter_all': 'All Visions',
      'filter_ethereal': 'Ethereal',
      'filter_nightmare': 'Nightmare',
      'filter_lucid': 'Lucid',
      'empty_archive': 'The Archive is Empty...',
      'remove_ads': 'REMOVE ADS',
      'upgrade_premium': 'Upgrade to Premium',

      // Wisdom Hub
      'wisdom_title': 'THE ORACLE\'S GUIDE',
      'card_1_title': 'THE LUCID PATH',
      'card_1_content':
          'Awareness is the key. Perform reality checks throughout the day to trigger clarity in the dream state.',
      'card_2_title': 'CIRCADIAN RHYTHM',
      'card_2_content':
          'Align with the sun. Sleep darkness boosts melatonin, the chemical messenger of the subconscious.',
      'card_3_title': 'SYMBOLIC LANGUAGE',
      'card_3_content':
          'Dreams speak in metaphors. Water is emotion, Fire is transformation, Flight is freedom.',
    },
    'tr': {
      // General
      'settings_title': 'KUTSAL AYARLAR',
      'language_label': 'Dil',
      'voice_label': 'Rehberin Sesi',
      'premium_label': 'Ustalık Seviyesi',
      'premium_subtitle': 'Kozmik Arşivi Aç',
      'test_premium': 'Premium Erişimi Test Et',

      // Navigation
      'nav_record': 'KAYIT',
      'nav_nebula': 'BULUTSU',
      'nav_wisdom': 'BİLGELİK',
      'nav_soul': 'RUH',

      // Messages
      'error_stars_misaligned': 'Yıldızlar hizalanmadı, ritüelini tekrar dene.',
      'success_ritual_complete': 'Ritüelin tamamlandı.',

      // Nebula
      'nebula_title': 'KOZMİK ARŞİV',
      'filter_all': 'Tüm Görüler',
      'filter_ethereal': 'Eterik',
      'filter_nightmare': 'Kabus',
      'filter_lucid': 'Berrak',
      'empty_archive': 'Arşiv Boş...',
      'remove_ads': 'REKLAMLARI KALDIR',
      'upgrade_premium': 'Premium\'a Yükselt',

      // Wisdom Hub
      'wisdom_title': 'KAHİNİN REHBERİ',
      'card_1_title': 'BERRAK YOL',
      'card_1_content':
          'Farkındalık anahtardır. Rüyada netliği tetiklemek için gün boyunca gerçeklik kontrolleri yapın.',
      'card_2_title': 'SİRKADİYEN RİTİM',
      'card_2_content':
          'Güneşle uyumlanın. Karanlık uyku, bilinçaltının kimyasal habercisi olan melatonini artırır.',
      'card_3_title': 'SEMBOLİK DİL',
      'card_3_content':
          'Rüyalar metaforlarla konuşur. Su duygudur, Ateş dönüşümdür, Uçuş özgürlüktür.',
    },
  };

  static String getString(String locale, String key) {
    return _localizedValues[locale]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}
