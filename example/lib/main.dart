import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:zoom_meeting_flutter_sdk/zoom_meeting_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoom Meeting Flutter SDK Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _zoomSDK = ZoomMeetingFlutterSdk();
  bool isInitialized = false;
  
  // Text controllers for the meeting form
  final TextEditingController _meetingNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zoom SDK Cross-Platform Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _meetingNumberController,
              decoration: const InputDecoration(labelText: 'Meeting Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Meeting Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isInitialized ? _joinMeting : initSDK,
              child: Text(isInitialized ? "Join Meeting" : "Initialize SDK"),
            ),
            const SizedBox(height: 16),
            Text(
              isInitialized
                  ? "SDK Initialized Successfully"
                  : "SDK Not Initialized",
              style: TextStyle(
                color: isInitialized ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> initSDK() async{
    try {
      debugPrint("initPlatformState");
      if (!isInitialized) {
        final jwtToken = generateJWT();
        debugPrint("initZoom -> isInitialized = $isInitialized");
        isInitialized = (await _zoomSDK.initZoom(jwtToken: jwtToken)) ?? false;
        debugPrint("initZoom -> result = $isInitialized");
                
        if (isInitialized) {
          setState(() {}); // Update UI to reflect initialized state
        }
      }
    } catch (e) {
      debugPrint("Error initializing Zoom: $e");
    }
  }

  Future<void> _joinMeting() async {
    debugPrint("Joining meeting");

    if (_meetingNumberController.text.isEmpty ||
        _nameController.text.isEmpty) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter meeting number and your name")),
      );
      return;
    }
    await _zoomSDK.joinMeting(
      meetingNumber: _meetingNumberController.text,
      meetingPassword: _passwordController.text,
      displayName: _nameController.text,
    );

  }


  String generateJWT() {
    final jwt = JWT(
      {
        'appKey': "DWDwOEUDRBStmIPuOE9KtQ",
        'mn': _meetingNumberController.text,
        'role': 0, // 0 for participant, 1 for host
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600, // 1 hour expiration
        'tokenExp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600, // 1 hour expiration
      },
    );

    final token = jwt.sign(SecretKey("heQqzroET0uzSNlSAmb1mZ4EaoVolep5"), algorithm: JWTAlgorithm.HS256);
    return token;
  }

}