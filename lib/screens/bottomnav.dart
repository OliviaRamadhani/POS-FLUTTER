import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pos2_flutter/screens/menu.dart';
import 'package:pos2_flutter/screens/home.dart';
import 'package:pos2_flutter/screens/profile.dart';
import 'package:pos2_flutter/screens/reservation.dart'; // Tambahkan ini

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  late Home HomePage;
  late Order order;
  late Profile profile;
  late Reservation reservation; // Tambahkan halaman reservasi
  int currentTabIndex = 0;

  @override
  void initState() {
    HomePage = Home();
    order = Order();
    profile = Profile();
    reservation = Reservation(); // Tambahkan ini
    pages = [HomePage, order, reservation, profile]; // Tambahkan reservasi ke daftar halaman

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Color(0xfff2f2f2),
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.shopping_bag_outlined, color: Colors.white),
          Icon(Icons.calendar_today_outlined, color: Colors.white), // Ikon reservasi
          Icon(Icons.person_outlined, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
