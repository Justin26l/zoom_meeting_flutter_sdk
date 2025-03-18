import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart';
import 'whoopwhoop/zoom_sdk_wrapper.dart';

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
  final _zoomSDK = ZoomSDKWrapper();
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
    try {
      if (!isInitialized) {
        debugPrint("initZoom -> isInitialized = $isInitialized");
        isInitialized = (await _zoomSDK.initZoom(jwtToken: "")) ?? false;
        debugPrint("initZoom -> result = $isInitialized");
        
        if (isInitialized) {
          setState(() {}); // Update UI to reflect initialized state
        }
      }
    } catch (e) {
      debugPrint("Error initializing Zoom: $e");
    }

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
              onPressed: isInitialized ? _joinMeeting : initPlatformState,
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
  
  Future<void> _joinMeeting() async {
    if (!isInitialized) {
      debugPrint("SDK not initialized");
      return;
    }
    
    if (_meetingNumberController.text.isEmpty ||
        _nameController.text.isEmpty) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter meeting number and your name")),
      );
      return;
    }
    
    // try {
      final meetingNumber = int.tryParse(_meetingNumberController.text);
      if (meetingNumber == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid meeting number")),
        );
        return;
      }

      await _zoomSDK.joinMeeting(
        meetingNumber: meetingNumber,
        meetingPassword: _passwordController.text,
        displayName: _nameController.text,
      );
    // } catch (e) {
    //   debugPrint("Error joining meeting: $e");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Failed to join meeting: $e")),
    //   );
    // }
  }
}