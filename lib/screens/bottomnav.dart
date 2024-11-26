import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pos2_flutter/screens/menu.dart';
import 'package:pos2_flutter/screens/home.dart';
import 'package:pos2_flutter/screens/profile.dart';
import 'package:pos2_flutter/screens/home2.dart';
import 'package:pos2_flutter/screens/menu2.dart';
import 'package:pos2_flutter/screens/profile2.dart';

class BottomNav extends StatefulWidget {
  final bool isAdmin; // Menentukan apakah user atau admin
  const BottomNav({super.key, required this.isAdmin});

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
    // Inisialisasi Halaman User
    userHome = Home();
    userMenu = Order();
    userProfile = Profile();

    // Inisialisasi Halaman Admin
    adminHome = Home2();
    adminMenu = Menu2();
    adminProfile = Profile2();

    // Tentukan halaman berdasarkan peran (user atau admin)
    pages = widget.isAdmin
        ? [adminHome, adminMenu, adminProfile]
        : [userHome, userMenu, userProfile];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        color: widget.isAdmin
            ? const Color.fromARGB(255, 13, 34, 70)
            : const Color.fromARGB(
                255, 13, 34, 70), // Warna berbeda untuk admin dan user
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
            color: widget.isAdmin
                ? Colors.white
                : const Color.fromARGB(255, 255, 255, 255),
          ),
          Icon(
            Icons.menu,
            size: 30,
            color: widget.isAdmin
                ? Colors.white
                : const Color.fromARGB(255, 255, 255, 255),
          ),
          Icon(
            Icons.person,
            size: 30,
            color: widget.isAdmin
                ? Colors.white
                : const Color.fromARGB(255, 255, 255, 255),
          ),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}