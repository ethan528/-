import 'package:flutter/material.dart';
import 'package:flutter_reading_buddy/main.dart';
import 'package:flutter_reading_buddy/screen/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final bool _isLogin = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _isLogin ? const MyApp() : const Login(),
      ),
    );
  }
}
