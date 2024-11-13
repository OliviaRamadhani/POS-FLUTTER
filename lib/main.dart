import 'package:flutter/material.dart';
import 'package:pos2_flutter/screens/welcome_screen.dart';
import 'package:pos2_flutter/theme/theme.dart';
import 'package:pos2_flutter/pages/bottomnav.dart';
import 'package:pos2_flutter/pages/home.dart';
import 'package:pos2_flutter/pages/login.dart';
import 'package:pos2_flutter/pages/onboarding.dart';
import 'package:pos2_flutter/pages/product_detail.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      title: 'Flutter Demo', // Judul aplikasi
      theme: lightMode, // Tema yang digunakan untuk aplikasi, pastikan lightMode sudah didefinisikan
      home: const WelcomeScreen(), // Layar pertama yang ditampilkan saat aplikasi dibuka
    );
  }
}