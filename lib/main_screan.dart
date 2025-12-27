// // lib/screens/translation_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:light_on/translate_provider.dart';
// import 'package:provider/provider.dart';


// class TranslationScreen extends StatefulWidget {
//   @override
//   _TranslationScreenState createState() => _TranslationScreenState();
// }

// class _TranslationScreenState extends State<TranslationScreen> {
//   final TextEditingController _textController = TextEditingController();
//   final FocusNode _textFocusNode = FocusNode();

//   @override
//   void dispose() {
//     _textController.dispose();
//     _textFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('English to Bengali Translator'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Input Section
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'English Text',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     TextField(
//                       controller: _textController,
//                       focusNode: _textFocusNode,
//                       maxLines: 4,
//                       decoration: InputDecoration(
//                         hintText: 'Enter English text to translate...',
//                         border: OutlineInputBorder(),
//                         contentPadding: EdgeInsets.all(12),
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Consumer<TranslationProvider>(
//                       builder: (context, provider, child) {
//                         return SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: provider.isLoading
//                                 ? null
//                                 : () {
//                                     if (_textController.text.trim().isNotEmpty) {
//                                       provider.translateText(_textController.text.trim());
//                                     }
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               foregroundColor: Colors.white,
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                             ),
//                             child: provider.isLoading
//                                 ? SizedBox(
//                                     height: 20,
//                                     width: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                     ),
//                                   )
//                                 : Text('Translate to Bengali'),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             // Output Section
//             Expanded(
//               child: Consumer<TranslationProvider>(
//                 builder: (context, provider, child) {
//                   if (provider.isLoading) {
//                     return Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(),
//                           SizedBox(height: 16),
//                           Text('Translating...'),
//                         ],
//                       ),
//                     );
//                   }

//                   if (provider.error.isNotEmpty) {
//                     return Card(
//                       color: Colors.red[50],
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.error_outline, color: Colors.red, size: 48),
//                             SizedBox(height: 16),
//                             Text(
//                               'Error',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             SizedBox(height: 8),
//                             Text(
//                               provider.error,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(color: Colors.red[700]),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }

//                   if (provider.translatedText.isEmpty) {
//                     return Card(
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.translate, size: 64, color: Colors.grey),
//                             SizedBox(height: 16),
//                             Text(
//                               'Translation will appear here',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }

//                   return Card(
//                     elevation: 4,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Bengali Translation',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.content_copy),
//                                 onPressed: () {
//                                   Clipboard.setData(
//                                     ClipboardData(text: provider.translatedText),
//                                   );
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Copied to clipboard'),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 12),
//                           Expanded(
//                             child: SingleChildScrollView(
//                               child: Text(
//                                 provider.translatedText,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   height: 1.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Consumer<TranslationProvider>(
//         builder: (context, provider, child) {
//           return FloatingActionButton(
//             onPressed: () {
//               _textController.clear();
//               provider.clearTranslation();
//               _textFocusNode.requestFocus();
//             },
//             child: Icon(Icons.clear),
//             tooltip: 'Clear',
//           );
//         },
//       ),
//     );
//   }
// }

// this is the end of the code snippets provided for comparison.