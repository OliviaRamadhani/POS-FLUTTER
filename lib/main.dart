import 'package:flutter/material.dart';

import 'package:pos2_flutter/screens/welcome_screen.dart';
import 'package:pos2_flutter/theme/theme.dart';
import 'package:pos2_flutter/screens/bottomnav.dart';
import 'package:pos2_flutter/screens/home.dart';
import 'package:pos2_flutter/screens/login.dart';
import 'package:pos2_flutter/screens/onboarding.dart';
import 'package:pos2_flutter/screens/product_detail.dart';
import 'package:pos2_flutter/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // Perbaikan: Menambahkan parameter isAdmin saat memanggil BottomNav
        home: const BottomNav(isAdmin: false)); // Set isAdmin sesuai dengan kondisi yang diinginkan (false untuk user)
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
