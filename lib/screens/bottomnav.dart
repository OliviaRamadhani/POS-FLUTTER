import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pos2_flutter/screens/menu.dart';
import 'package:pos2_flutter/screens/home.dart';
import 'package:pos2_flutter/screens/profile.dart';
import 'package:pos2_flutter/screens/home2.dart';
import 'package:pos2_flutter/screens/menu2.dart';
import 'package:pos2_flutter/screens/profile2.dart';
import '../models/user_model.dart'; // File yang berisi kelas User dan Role

class BottomNav extends StatefulWidget {
  final User user; // Menerima objek User
  const BottomNav({super.key, required this.user});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;

  // Halaman User
  late Home userHome;
  late Order userMenu;
  late Profile userProfile;

  // Halaman Admin
  late Home2 adminHome;
  late Menu2 adminMenu;
  late Profile2 adminProfile;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();

    // Inisialisasi Halaman User
    userHome = Home();
    userMenu = Order();
    userProfile = Profile();

    // Inisialisasi Halaman Admin
    adminHome = Home2();
    adminMenu = Menu2();
    adminProfile = Profile2();

    // Tentukan halaman berdasarkan role.name
    pages = widget.user.role.name == "admin"
        ? [adminHome, adminMenu, adminProfile]
        : [userHome, userMenu, userProfile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: const Color.fromARGB(255, 13, 34, 70),
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
