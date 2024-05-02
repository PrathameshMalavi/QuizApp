import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screen/HomeScreen.dart';
import 'package:flutter_app/screen/McqScreen.dart';
import 'package:flutter_app/screen/Question.dart';
import 'package:flutter_app/screen/SplashScreen.dart';
import 'package:flutter_app/screen/home.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        ),

      home: SplashScreen(),
      // home: TFQuestionScreen(),
    );
  }
}