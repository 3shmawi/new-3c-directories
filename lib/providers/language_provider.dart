// import 'package:flutter/material.dart';
//
// import '../../services/queue_service.dart';
//
// class LanguageProvider extends ChangeNotifier {
//   final QueueService _queueService = QueueService();
//   Locale _locale = const Locale('en');
//
//   LanguageProvider() {
//     _loadSavedLanguage();
//   }
//
//   Future<void> _loadSavedLanguage() async {
//     final String savedLanguage = await _queueService.getLanguage();
//     _locale = Locale(savedLanguage);
//     notifyListeners();
//   }
//
//   Locale get locale => _locale;
//
//   Future<void> setLocale(Locale locale) async {
//     if (_locale == locale) return;
//
//     _locale = locale;
//     await _queueService.setLanguage(locale.languageCode);
//     notifyListeners();
//   }
//
//   bool get isArabic => _locale.languageCode == 'ar';
// }
