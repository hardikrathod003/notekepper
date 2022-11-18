import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notekepper/screens/homePage.dart';
import 'package:notekepper/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "intro_Screen",
      routes: {
        '/': (context) => HomePage(),
        'intro_Screen': (context) => IntroScreen(),
      },
    ),
  );
}
