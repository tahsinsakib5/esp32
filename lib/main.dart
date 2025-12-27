import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ensure your firebase options are setup
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LedControlPage(),
    );
  }
}

class LedControlPage extends StatefulWidget {
  @override
  _LedControlPageState createState() => _LedControlPageState();
}

class _LedControlPageState extends State<LedControlPage> {
  final DatabaseReference ledRef =
      FirebaseDatabase.instance.ref("led/status");

  bool ledStatus = false;

  @override
  void initState() {
    super.initState();

    // Listen from firebase (real-time update)
    ledRef.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value is bool) {
        setState(() {
          ledStatus = value;
        });
      }
    });
  }

  Future<void> toggleLed() async {
    await ledRef.set(!ledStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP32 LED Control"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ledStatus ? Icons.lightbulb : Icons.lightbulb_outline,
              size: 120,
              color: ledStatus ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 20),
            Switch(
              value: ledStatus,
              onChanged: (value) {
                toggleLed();
              },
              activeColor: Colors.amber,
            ),
            const SizedBox(height: 10),
            Text(
              ledStatus ? "LED is ON" : "LED is OFF",
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
