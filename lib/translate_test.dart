// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class DeepSeekService {
//   static final String _apiKey = dotenv.get('DEEPSEEK_API_KEY');
//   static final String _apiUrl = dotenv.get('DEEPSEEK_API_URL');

//   static Future<String> translateText({
//     required String text,
//     required String targetLanguage,
//     String sourceLanguage = 'auto',
//   }) async {
//     try {
//       // Input validation
//       if (text.trim().isEmpty) {
//         throw Exception('Please enter text to translate');
//       }

//       if (text.length > 5000) {
//         throw Exception('Text too long. Please enter less than 5000 characters.');
//       }

//       final response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_apiKey',
//         },
//         body: jsonEncode({
//           'model': 'deepseek-chat',
//           'messages': [
//             {
//               'role': 'system',
//               'content': 'You are a professional translator. Translate the given text accurately while preserving the meaning, tone, and context. Only return the translated text without any additional explanations, notes, or brackets.',
//             },
//             {
//               'role': 'user',
//               'content': 'Translate the following text from $sourceLanguage to $targetLanguage. Only provide the translation without any additional text:\n\n$text',
//             }
//           ],
//           'max_tokens': 2000,
//           'temperature': 0.1, // Lower temperature for more consistent translations
//           'stream': false,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
        
//         if (data['choices'] == null || data['choices'].isEmpty) {
//           throw Exception('No translation received from API');
//         }
        
//         final translatedText = data['choices'][0]['message']['content'].toString().trim();
        
//         // Validate translation result
//         if (translatedText.isEmpty) {
//           throw Exception('Empty translation received');
//         }
        
//         return translatedText;
//       } else if (response.statusCode == 401) {
//         throw Exception('Invalid API key. Please check your DeepSeek API key.');
//       } else if (response.statusCode == 429) {
//         throw Exception('Rate limit exceeded. Please try again later.');
//       } else if (response.statusCode >= 500) {
//         throw Exception('Server error. Please try again later.');
//       } else {
//         throw Exception('Translation failed: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       if (e is http.ClientException) {
//         throw Exception('Network error: Please check your internet connection');
//       }
//       rethrow;
//     }
//   }

//   static Future<List<String>> getSupportedLanguages() async {
//     // Enhanced language list with emojis and common names
//     return [
//       'English 🇺🇸',
//       'Spanish 🇪🇸',
//       'French 🇫🇷',
//       'German 🇩🇪',
//       'Italian 🇮🇹',
//       'Portuguese 🇵🇹',
//       'Russian 🇷🇺',
//       'Chinese 🇨🇳',
//       'Japanese 🇯🇵',
//       'Korean 🇰🇷',
//       'Arabic 🇸🇦',
//       'Hindi 🇮🇳',
//       'Turkish 🇹🇷',
//       'Dutch 🇳🇱',
//       'Greek 🇬🇷',
//       'Hebrew 🇮🇱',
//       'Thai 🇹🇭',
//       'Vietnamese 🇻🇳',
//       'Indonesian 🇮🇩',
//       'Malay 🇲🇾',
//       'Swedish 🇸🇪',
//       'Norwegian 🇳🇴',
//       'Danish 🇩🇰',
//       'Finnish 🇫🇮',
//       'Polish 🇵🇱',
//       'Czech 🇨🇿',
//       'Hungarian 🇭🇺',
//       'Romanian 🇷🇴',
//       'Bulgarian 🇧🇬',
//       'Ukrainian 🇺🇦',
//     ];
//   }

//   // Helper method to get language code without emoji
//   static String getLanguageCode(String languageWithEmoji) {
//     return languageWithEmoji.split(' ')[0];
//   }

//   // Detect language of input text
//   static Future<String> detectLanguage(String text) async {
//     try {
//       final response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $_apiKey',
//         },
//         body: jsonEncode({
//           'model': 'deepseek-chat',
//           'messages': [
//             {
//               'role': 'system',
//               'content': 'You are a language detection expert. Identify the language of the given text and return only the language name in English.',
//             },
//             {
//               'role': 'user',
//               'content': 'Detect the language of this text and return only the language name:\n\n$text',
//             }
//           ],
//           'max_tokens': 50,
//           'temperature': 0.1,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['choices'][0]['message']['content'].toString().trim();
//       } else {
//         return 'Unknown';
//       }
//     } catch (e) {
//       return 'Unknown';
//     }
//   }

//   // Get translation history (simulated - in real app you'd use a database)
//   static List<Map<String, String>> getTranslationHistory() {
//     // This would typically come from a database
//     return [];
//   }
// }