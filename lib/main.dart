import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(DeepSeekTranslatorApp());
}

class DeepSeekTranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TranslatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TranslatorPage extends StatefulWidget {
  @override
  _TranslatorPageState createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  TextEditingController inputController = TextEditingController();
  String translatedText = "";

  final String apiKey = "sk-6aad2153cdae43529cf8af2873ae87f2";

  // Available languages
  final List<String> languages = [
    "English",
    "Bangla",
    "Hindi",
    "Arabic",
    "Chinese",
    "Spanish",
    "French",
    "German",
    "Japanese",
    "Korean",
  ];

  String selectedLanguage = "English";

  Future<void> translateText() async {
    final url = Uri.parse("https://api.deepseek.com/v1/chat/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "deepseek-chat",
        "messages": [
          {
            "role": "system",
            "content": "You are a translation assistant."
          },
          {
            "role": "user",
            "content":
                "Translate to $selectedLanguage: ${inputController.text}"
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        translatedText = json["choices"][0]["message"]["content"];
      });
    } else {
      setState(() {
        translatedText = "Error: ${response.body}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DeepSeek Translator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Language Dropdown
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              items: languages
                  .map((lang) =>
                      DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Select Translation Language",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Text input
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                labelText: "Enter text",
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 3,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: translateText,
              child: Text("Translate"),
            ),

            SizedBox(height: 20),

            Text(
              translatedText,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
