// // lib/providers/translation_provider.dart
// import 'package:flutter/foundation.dart';
// import 'package:light_on/translate_test.dart';


// class TranslationProvider with ChangeNotifier {
//   final TranslationService _translationService;
//   String _translatedText = '';
//   bool _isLoading = false;
//   String _error = '';

//   TranslationProvider({required TranslationService translationService})
//       : _translationService = translationService;

//   String get translatedText => _translatedText;
//   bool get isLoading => _isLoading;
//   String get error => _error;

//   Future<void> translateText(String text, {String targetLang = 'BN'}) async {
//     _isLoading = true;
//     _error = '';
//     notifyListeners();

//     try {
//       _translatedText = await _translationService.translateText(
//         text,
//         targetLang: targetLang,
//       );
//     } catch (e) {
//       _error = e.toString();
//       _translatedText = '';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void clearTranslation() {
//     _translatedText = '';
//     _error = '';
//     notifyListeners();
//   }
// }