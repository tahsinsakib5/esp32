// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:light_on/translate_test.dart';


// class TranslatorScreen extends StatefulWidget {
//   const TranslatorScreen({super.key});

//   @override
//   State<TranslatorScreen> createState() => _TranslatorScreenState();
// }

// class _TranslatorScreenState extends State<TranslatorScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final TextEditingController _translatedController = TextEditingController();
//   final FocusNode _textFocusNode = FocusNode();
//   final FocusNode _translatedFocusNode = FocusNode();

//   String _selectedLanguage = 'Spanish 🇪🇸';
//   bool _isTranslating = false;
//   bool _isDetectingLanguage = false;
//   List<String> _supportedLanguages = [];
//   String _detectedLanguage = '';
//   String _translationTime = '';
//   int _characterCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadLanguages();
//     _setupControllers();
//   }

//   void _setupControllers() {
//     _textController.addListener(() {
//       setState(() {
//         _characterCount = _textController.text.length;
//       });
//     });
//   }

//   Future<void> _loadLanguages() async {
//     final languages = await DeepSeekService.getSupportedLanguages();
//     setState(() {
//       _supportedLanguages = languages;
//     });
//   }

//   Future<void> _detectLanguage() async {
//     if (_textController.text.trim().isEmpty) return;

//     setState(() {
//       _isDetectingLanguage = true;
//       _detectedLanguage = '';
//     });

//     try {
//       final detected = await DeepSeekService.detectLanguage(_textController.text);
//       setState(() {
//         _detectedLanguage = detected;
//       });
//       _showSnackBar('Detected language: $detected');
//     } catch (e) {
//       _showSnackBar('Language detection failed');
//     } finally {
//       setState(() {
//         _isDetectingLanguage = false;
//       });
//     }
//   }

//   Future<void> _translateText() async {
//     final text = _textController.text.trim();
//     if (text.isEmpty) {
//       _showSnackBar('Please enter some text to translate');
//       return;
//     }

//     if (text.length > 5000) {
//       _showSnackBar('Text too long. Please enter less than 5000 characters.');
//       return;
//     }

//     // Unfocus to hide keyboard
//     _textFocusNode.unfocus();
//     _translatedFocusNode.unfocus();

//     setState(() {
//       _isTranslating = true;
//       _translatedController.clear();
//       _translationTime = '';
//       _detectedLanguage = '';
//     });

//     final stopwatch = Stopwatch()..start();

//     try {
//       final translatedText = await DeepSeekService.translateText(
//         text: text,
//         targetLanguage: DeepSeekService.getLanguageCode(_selectedLanguage),
//       );

//       stopwatch.stop();

//       setState(() {
//         _translatedController.text = translatedText;
//         _translationTime = 'Translated in ${stopwatch.elapsedMilliseconds}ms';
//       });

//       _showSnackBar('Translation completed!');
//     } catch (e) {
//       final errorMessage = e.toString().replaceAll('Exception: ', '');
//       _showErrorDialog(errorMessage);
//     } finally {
//       setState(() {
//         _isTranslating = false;
//       });
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Row(
//           children: [
//             Icon(Icons.error_outline, color: Colors.red),
//             SizedBox(width: 8),
//             Text('Translation Error'),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _copyToClipboard() {
//     if (_translatedController.text.isNotEmpty) {
//       Clipboard.setData(ClipboardData(text: _translatedController.text));
//       _showSnackBar('Copied to clipboard!');
//     }
//   }

//   void _swapTexts() {
//     if (_translatedController.text.isNotEmpty) {
//       final tempText = _textController.text;
//       _textController.text = _translatedController.text;
//       _translatedController.text = tempText;
//       _showSnackBar('Texts swapped!');
//     }
//   }

//   void _clearText() {
//     setState(() {
//       _textController.clear();
//       _translatedController.clear();
//       _characterCount = 0;
//       _detectedLanguage = '';
//       _translationTime = '';
//     });
//     _textFocusNode.unfocus();
//     _translatedFocusNode.unfocus();
//     _showSnackBar('Cleared all text');
//   }

//   void _speakText(String text) {
//     // This would integrate with text-to-speech in a real app
//     _showSnackBar('Text-to-speech feature would play: ${text.substring(0, 30)}...');
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _shareTranslation() {
//     // This would integrate with share functionality in a real app
//     if (_translatedController.text.isNotEmpty) {
//       _showSnackBar('Share feature would share the translation');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('DeepSeek Translator'),
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//         elevation: 4,
//         actions: [
//           if (_textController.text.isNotEmpty && !_isTranslating)
//             IconButton(
//               icon: const Icon(Icons.translate),
//               onPressed: _translateText,
//               tooltip: 'Translate',
//             ),
//           IconButton(
//             icon: const Icon(Icons.swap_horiz),
//             onPressed: _swapTexts,
//             tooltip: 'Swap texts',
//           ),
//           IconButton(
//             icon: const Icon(Icons.clear_all),
//             onPressed: _clearText,
//             tooltip: 'Clear all',
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Language Selection Card
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         Icon(Icons.language, color: Colors.blue, size: 20),
//                         SizedBox(width: 8),
//                         Text(
//                           'Translation Settings',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Target Language:',
//                                 style: TextStyle(fontWeight: FontWeight.w500),
//                               ),
//                               const SizedBox(height: 4),
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.grey.shade300),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: DropdownButton<String>(
//                                   value: _selectedLanguage,
//                                   isExpanded: true,
//                                   underline: const SizedBox(),
//                                   icon: const Icon(Icons.arrow_drop_down),
//                                   items: _supportedLanguages.map((String language) {
//                                     return DropdownMenuItem<String>(
//                                       value: language,
//                                       child: Text(
//                                         language,
//                                         style: const TextStyle(fontSize: 16),
//                                       ),
//                                     );
//                                   }).toList(),
//                                   onChanged: _isTranslating ? null : (String? newValue) {
//                                     if (newValue != null) {
//                                       setState(() {
//                                         _selectedLanguage = newValue;
//                                       });
//                                     }
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (_textController.text.isNotEmpty && !_isTranslating)
//                           Padding(
//                             padding: const EdgeInsets.only(left: 12.0),
//                             child: Column(
//                               children: [
//                                 const Text(
//                                   'Detect Language',
//                                   style: TextStyle(fontWeight: FontWeight.w500),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 IconButton(
//                                   icon: _isDetectingLanguage
//                                       ? const SizedBox(
//                                           width: 20,
//                                           height: 20,
//                                           child: CircularProgressIndicator(strokeWidth: 2),
//                                         )
//                                       : const Icon(Icons.search),
//                                   onPressed: _detectLanguage,
//                                   tooltip: 'Detect input language',
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                     if (_detectedLanguage.isNotEmpty)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           'Detected: $_detectedLanguage',
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Input and Output Sections
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Input Section
//                   Expanded(
//                     child: _buildTextFieldSection(
//                       controller: _textController,
//                       focusNode: _textFocusNode,
//                       title: 'Input Text',
//                       icon: Icons.input,
//                       hintText: 'Enter text to translate...',
//                       isInput: true,
//                     ),
//                   ),

//                   const SizedBox(width: 16),

//                   // Output Section
//                   Expanded(
//                     child: _buildTextFieldSection(
//                       controller: _translatedController,
//                       focusNode: _translatedFocusNode,
//                       title: 'Translated Text',
//                       icon: Icons.output,
//                       hintText: 'Translation will appear here...',
//                       isInput: false,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Translation Info and Actions
//             if (_translationTime.isNotEmpty || _characterCount > 0)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (_characterCount > 0)
//                       Text(
//                         'Characters: $_characterCount',
//                         style: const TextStyle(color: Colors.grey, fontSize: 12),
//                       ),
//                     if (_translationTime.isNotEmpty)
//                       Text(
//                         _translationTime,
//                         style: const TextStyle(color: Colors.green, fontSize: 12),
//                       ),
//                   ],
//                 ),
//               ),

//             // Action Buttons
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed: _isTranslating ? null : _translateText,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue.shade700,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 2,
//                       ),
//                       icon: _isTranslating
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                               ),
//                             )
//                           : const Icon(Icons.translate),
//                       label: _isTranslating
//                           ? const Text('Translating...', style: TextStyle(fontSize: 16))
//                           : const Text('Translate', style: TextStyle(fontSize: 16)),
//                     ),
//                   ),
//                   if (_translatedController.text.isNotEmpty) ...[
//                     const SizedBox(width: 8),
//                     IconButton(
//                       icon: const Icon(Icons.content_copy),
//                       onPressed: _copyToClipboard,
//                       tooltip: 'Copy translation',
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.green.shade50,
//                         padding: const EdgeInsets.all(16),
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     IconButton(
//                       icon: const Icon(Icons.volume_up),
//                       onPressed: () => _speakText(_translatedController.text),
//                       tooltip: 'Speak translation',
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.orange.shade50,
//                         padding: const EdgeInsets.all(16),
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     IconButton(
//                       icon: const Icon(Icons.share),
//                       onPressed: _shareTranslation,
//                       tooltip: 'Share translation',
//                       style: IconButton.styleFrom(
//                         backgroundColor: Colors.purple.shade50,
//                         padding: const EdgeInsets.all(16),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextFieldSection({
//     required TextEditingController controller,
//     required FocusNode focusNode,
//     required String title,
//     required IconData icon,
//     required String hintText,
//     required bool isInput,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, size: 20, color: Colors.grey),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const Spacer(),
//                 if (controller.text.isNotEmpty && !_isTranslating)
//                   IconButton(
//                     icon: const Icon(Icons.clear, size: 18),
//                     onPressed: () {
//                       controller.clear();
//                       if (isInput) {
//                         setState(() {
//                           _characterCount = 0;
//                           _detectedLanguage = '';
//                         });
//                       }
//                     },
//                     tooltip: 'Clear',
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   maxLines: null,
//                   expands: true,
//                   textAlignVertical: TextAlignVertical.top,
//                   readOnly: !isInput && _isTranslating,
//                   decoration: InputDecoration(
//                     hintText: hintText,
//                     contentPadding: const EdgeInsets.all(12),
//                     border: InputBorder.none,
//                     suffixIcon: isInput && controller.text.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(Icons.translate, size: 18),
//                             onPressed: _translateText,
//                             tooltip: 'Translate',
//                           )
//                         : null,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     _translatedController.dispose();
//     _textFocusNode.dispose();
//     _translatedFocusNode.dispose();
//     super.dispose();
//   }
// }