import 'package:flutter/material.dart';

class Reservation extends StatelessWidget {
  const Reservation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservations")),
      body: Center(
        child: Text("Reservation Page - Add your reservations here"),
      ),
    );
  }
}
